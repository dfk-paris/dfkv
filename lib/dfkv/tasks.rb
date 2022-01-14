require 'csv'
require 'roo'
require 'pry'

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
    translations = read_excel(ENV['DATA_TRANSLATIONS'], "translations")

    File.open 'frontend/public/translations.json', 'w+' do |f|
      f.write JSON.pretty_generate(translations)
    end

    elastic = Dfkv::Elastic.new
    elastic.reset!

    # records
    pb = Dfkv.progress_bar('indexing records', records.size)
    records.each do |id, record|
      record['tags'] = to_id_list(record['tags'])
      record['involved'] = to_id_list(record['involved'])
      record['creators'] = to_id_list(record['creators'])
      record['translators'] = to_id_list(record['translators'])
      record['text_types'] = to_id_list(record['text_types'])
      record['date'] = to_date(record['date'])

      record['volumes'] = volumes.values.select{|e| e['record_id'] == id}
      record['volumes'].each do |volume|
        id = volume['journal_id']
        # binding.pry unless journals[id]
        volume['journal'] = journals[id]
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
        {'index' => {'_index' => "#{elastic.config[:prefix]}-records"}},
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
      # binding.pry if sheet_name == 'Volume_ID'
      results[record[primary_key]] = record
    end
    
    book.close
    results
  end
end
