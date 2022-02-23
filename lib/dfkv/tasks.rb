require 'csv'
require 'roo'

begin
  require 'pry'
rescue LoadError => e
end

module Dfkv::Tasks
  def self.to_id_list(value)
    case value
    when nil then []
    when Integer then [value.to_i]
    when String then value.split(',').map(&:to_i)
    else
      binding.pry
    end
  end

  def self.to_date(value)
    case value
    when nil then value
    when Integer then Date.new(value, 1, 1)
    when String
      return Date.parse(value)

      if value.match?(/[0-9]{4}-[0-9]{2}-[0-9]{2}/)
        Date.parse(value)
      end
    else
      puts 'date'
      binding.pry
    end
  end

  def self.wikidata_for(id)
    return nil unless id

    cache_file = "#{ENV['WIKIDATA_CACHE_DIR']}/#{id}.json"
    return JSON.load(File.read cache_file) if File.exists?(cache_file)

    url = "https://www.wikidata.org/wiki/Special:EntityData/#{id}.json"
    puts "retrieving '#{url}'"

    response = Faraday.get(url)
    # we deal with qid redirects, e.g. Q1873356
    entity = JSON.parse(response.body)['entities'].values.first

    File.open cache_file, 'w' do |f|
      f.write JSON.pretty_generate(entity)
    end

    entity
  end

  def self.try(&block)
    yield
  rescue NoMethodError => e
    nil
  end

  def self.label_for(entity)
    v = entity['labels']['en'] || entity['labels']['fr'] || entity['labels']['de']
    v['value']
  end

  def self.index
    records = read_excel(ENV['DATA_FILE_RECORDS'], 'Data_complet')
    volumes = read_excel(ENV['DATA_FILE_MASTER'], 'Volume_ID')
    journals = read_excel(ENV['DATA_FILE_MASTER'], 'Journal')
    text_types = read_excel(ENV['DATA_FILE_MASTER'], 'Type de texte')
    tags = read_excel(ENV['DATA_FILE_MASTER'], 'Sujets')
    categories = read_excel(ENV['DATA_FILE_MASTER'], 'Rubrique')
    locations = read_excel(ENV['DATA_FILE_MASTER'], 'Lieu de publication')
    editors = read_excel(ENV['DATA_FILE_MASTER'], "Maison d'édition")
    people = read_excel(ENV['DATA_FILE_MASTER'], "Personnes")
    roles = read_excel(ENV['DATA_FILE_MASTER'], "Rôles de personnes")
    attribs = read_excel(ENV['DATA_FILE_MASTER'], "Attributs")
    projects = read_excel(ENV['DATA_FILE_MASTER'], 'Projets')
    translations = read_excel(ENV['DATA_TRANSLATIONS'], "translations")

    self.dump_json(translations, 'frontend/public/translations.json')
    self.dump_json(projects, 'frontend/public/projects.json')

    elastic = Dfkv::Elastic.new
    elastic.reset!

    # link people by identify (id_2)
    lookup = {}
    people.each do |id, person|
      lookup[person['id_2']] ||= []
      lookup[person['id_2']] << person['display_name']
    end
    people.each do |id, person|
      others = lookup[person['id_2']].select{|e| e != person['display_name']}
      person['display_name'] = ([person['display_name']] + others).uniq
    end

    # get wikidata for people
    puts "fetching and parsing wikidata entities ..."
    system 'mkdir', '-p', ENV['WIKIDATA_CACHE_DIR']
    people.each do |id, person|
      next unless person['wikidata_id']
      entity = wikidata_for(person['wikidata_id'])

      if v = try{entity['claims']['P569'].first['mainsnak']['datavalue']['value']['time']}
        person['birth_date'] = v
      end

      if v = try{entity['claims']['P19'].first['mainsnak']['datavalue']['value']['id']}
        place = wikidata_for(v)

        person['birth_place'] = {
          'id' => v,
          'name' => label_for(place)
        }
      end

      if v = try{entity['claims']['P570'].first['mainsnak']['datavalue']['value']['time']}
        person['death_date'] = v
      end

      if v = try{entity['claims']['P20'].first['mainsnak']['datavalue']['value']['id']}
        place = wikidata_for(v)

        person['death_place'] = {
          'id' => v,
          'name' => label_for(place)
        }
      end
    end

    # records
    pb = Dfkv.progress_bar('indexing records', records.size)
    records.each do |record_id, record|
      record['tags'] = to_id_list(record['tags'])
      record['involved'] = to_id_list(record['involved'])
      record['creators'] = to_id_list(record['creators'])
      record['translators'] = to_id_list(record['translators'])
      record['text_types'] = to_id_list(record['text_types'])
      record['date'] = to_date(record['date'])

      if id = record['project_id']
        binding.pry unless projects[id]
        record['project'] = projects[id]
      end

      record['volumes'] = volumes.values.select{|e| e['record_id'] == record_id}
      record['volumes'].each do |volume|
        id = volume['journal_id']
        # binding.pry unless journals[id]
        volume['journal'] = journals[id]
        if iiif = volume['link_iiif']
          volume['manifest'] = iiif.gsub(/\/canvas.*$/, '/manifest.json')
          volume['canvas'] = iiif.gsub(/\.json$/, '')
        end
      end

      # if id = record['journal_id']
      #   binding.pry unless journals[id]
      #   record['journal'] = journals[id]
      # end

      if id = record['location_id']
        binding.pry unless locations[id]
        record['location'] = locations[id]
      end

      if id = record['editor_id']
        binding.pry unless editors[id]
        record['editor'] = editors[id]
      end

      if id = record['rubric_id']
        binding.pry unless categories[id]
        record['rubric'] = categories[id]
      end

      record['text_types'].map! do |id|
        binding.pry unless text_types[id]
        text_types[id]
      end

      record['involved'].map! do |id|
        binding.pry unless people[id]
        people[id]
      end

      record['creators'].map! do |id|
        binding.pry unless people[id]
        people[id]
      end

      record['translators'].map! do |id|
        binding.pry unless people[id]
        people[id]
      end

      record['tags'].map! do |id|
        binding.pry unless tags[id]
        tags[id]
      end

      # binding.pry

      elastic.bulk([
        {'index' => {'_id' => record['id'], '_index' => "#{elastic.config[:prefix]}-records"}},
        record
      ], batch_size: 500)

      pb.increment
    rescue => e
      puts e
      puts e.backtrace
      binding.pry
    end

    elastic.bulk_commit
    elastic.refresh
  end

  def self.read_excel(file, sheet_name, primary_key = 'id')
    puts "reading sheet '#{sheet_name}' from '#{file}'"

    book = Roo::Spreadsheet.open(file)
    sheet = book.sheet_for(sheet_name)

    headers = sheet.row(1).map.with_index{|e, i| sheet.row(2)[i] ||sheet.row(1)[i] }
    results = {}
    (3..sheet.last_row).each do |i|
      values = sheet.row(i)
      record = headers.zip(values).to_h
      # binding.pry if sheet_name == 'Data_complet'
      results[record[primary_key]] = record
    end
    
    book.close
    results
  end

  def with_csv(file, &block)
    puts "reading CSV from '#{file}'"

    CSV.read(read).each do |row|
      yield row
    end
  end

  def self.dump_json(data, file)
    File.open file, 'w+' do |f|
      f.write JSON.pretty_generate(data)
    end
  end
end
