class Dfkv::Elastic

  def config
    return {
      url: ENV['ELASTIC_URL'],
      prefix: ENV['ELASTIC_PREFIX']
    }
  end

  def reset!
    ['records'].each do |name|
      drop_index(name) if index_exists?(name)
    end

    create_index 'records', {
      'settings' => {
        
      },
      'mappings' => {
        'properties' => {
          'date' => {
            'type' => 'date',
            'format' => 'strict_date_optional_time_nanos'
          }
        }
      }
    }
  end

  def drop_index(name)
    request 'delete', "/#{config[:prefix]}-#{name}"
    require_ok!
  end

  def find(id)
    request 'get', "/#{config[:prefix]}-records/_doc/#{id}"
    require_ok!

    return JSON.parse(@response.body)
  end

  def search(params = {})
    query = build_query(params)
    request 'post', "/#{config[:prefix]}-records/_search", nil, query
    require_ok!
    result = JSON.parse(@response.body)

    # binding.pry

    ['year', 'project_id'].each do |a|
      query = build_query(params, without: a)
      request 'post', "/#{config[:prefix]}-records/_search", nil, query
      require_ok!
      all_results = JSON.parse(@response.body)
      result['aggregations'][a] = all_results['aggregations'][a]
    end

    result
  end

  def build_query(params, without: nil)
    filters = []
    locale = params['locale'] || 'de'

    unless params['id'].empty?
      filters << {
        'terms' => {'id' => params['id']}
      }
    end

    to_array(params['creator']).each do |v|
      filters << {
        'term' => {'creators.display_name.keyword' => v}
      }
    end

    to_array(params['involved']).each do |v|
      filters << {
        'term' => {'involved.display_name.keyword' => v}
      }
    end

    to_array(params['journal']).each do |v|
      filters << {
        'term' => {"volumes.journal.#{locale}.keyword" => v}
      }
    end

    to_array(params['type']).each do |v|
      filters << {
        'term' => {"text_types.#{locale}.keyword" => v}
      }
    end

    if without != 'year'
      if v = params['from']
        filters << {
          'range' => {'date' => {'gte' => "#{v}-01-01T00:00:00Z"}}
        }
      end

      if v = params['to']
        filters << {
          'range' => {'date' => {'lte' => "#{v}-12-31T23:59:59Z"}}
        }
      end
    end

    if without != 'project_id'
      if id = params['project_id']
        filters << {
          'term' => {'project_id' => {'value' => id}}
        }
      end
    end

    full_text = if params['terms'] && params['terms'] != ''
      [
        {'simple_query_string' => {'query' => params['terms']}}
      ]
    end
    
    query = {
      'from' => (params['page'] - 1) * params['per_page'],
      'size' => params['per_page'],
      'query' => {
        'bool' => {
          'must' => full_text,
          'filter' => filters
        },
      },
      'aggs' => {
        "year" => {
          "date_histogram" => {
            "field" => 'date',
            "interval" => 'year',
            "format" => "yyyy"
          }
        },
        "project_id" => {
          "terms" => {"field" => "project_id"}
        },
        "creator" => {
          "terms" => {
            "field" => "creators.display_name.keyword",
            "size" => 10000
          }
        },
        "involved" => {
          "terms" => {
            "field" => "involved.display_name.keyword",
            "size" => 10000
          }
        },
        "journal" => {
          "terms" => {
            "field" => "volumes.journal.#{locale}.keyword",
            "size" => 500
          }
        },
        "type" => {
          "terms" => {
            "field" => "text_types.#{locale}.keyword",
            "size" => 500
          }
        }
      }
    }

    if s = params['sort']
      field = {
        'title' => 'title.keyword'
      }[s] || s

      query['sort'] = {field => {'order' => 'asc'}}
    end

    query
  end

  def create_index(name, options = {})
    request 'put', "/#{config[:prefix]}-#{name}", nil, options
    require_ok!

    # {
    #   "settings" => {
    #     # "number_of_shards" => 1,
    #     # 'max_result_window' => 50000,
    #     # "analysis" => {
    #     #   "analyzer" => {
    #     #     "folding" => {
    #     #       "tokenizer" => "standard",
    #     #       "filter" => ["lowercase", "asciifolding"]
    #     #     },
    #     #     'case_insensitive_sort' => {
    #     #       'tokenizer' => 'keyword',
    #     #       'filter' => ['lowercase']
    #     #     }
    #     #   }
    #     # }
    #   }
    # }
  end

  def index_exists?(name)
    @response = raw_request 'head', "/#{config[:prefix]}-#{name}"
    @response.status != 404
  end

  def reset_index(name)
    drop_index(name) if index_exists?(name)
    create_index(name)
  end

  def refresh
    request "post", "/_refresh"
    require_ok!
  end

  def index(name, doc)
    request 'post', "/#{config[:prefix]}-#{name}/_doc/#{doc['id']}", nil, doc
    require_ok!
  end

  def bulk(operations, batch_size: 500)
    operations = [operations] unless operations.is_a?(Array)

    @bulk_backlog ||= []
    @bulk_backlog += operations

    bulk_commit if @bulk_backlog.size >= batch_size
  end

  def bulk_commit
    return if @bulk_backlog.nil? || @bulk_backlog.empty?

    body = @bulk_backlog.map{|d| d.to_json}.join("\n")
    @bulk_backlog = []
    request "post", "/_bulk", nil, "#{body}\n"
    require_ok!
  end


  protected

    def request(method, path = nil, query = {}, body = nil, headers = {})
      @response = raw_request(method, path, query, body, headers)

      if @response.status >= 200 && @response.status <= 299
        [@response.status, @response.headers, JSON.load(@response.body)]
      else
        # binding.pry
        raise Exception.new([@response.status, @response.headers, JSON.load(@response.body)])
      end
    end

    def raw_request(method, path = nil, query = {}, body = nil, headers = {})
      raise 'path cannot be nil' if path.nil?

      query ||= {}
      url = "#{config[:url]}#{path}"

      if body && !body.is_a?(String)
        body = JSON.dump(body)
      end

      # puts "#{method.upcase} #{url}"

      client.run_request method.to_sym, url, body, headers do |r|
        r.params.update(query)
      end
    end

    def require_ok!
      if @response.status < 200 || @response.status >= 400
        binding.pry
      end
    end

    def client
      @client ||= Faraday.new(
        url: config[:url],
        headers: {
          'content-type' => 'application/json',
          'accept' => 'application/json'
        }
      )
    end

    def to_array(value)
      case value
      when String then value.split('|')
      when nil then []
      else
        raise "can't generate array from #{value.inspect}"
      end
    end

  # def tokenize(query_string)
  #   query_string = "" if query_string.blank?
  #   query_string = query_string.join(' ') if query_string.is_a?(Array)

  #   query_string.scan(/\"[^\"]*\"|[^\"\s]+/).select do |term|
  #     term.size >= 3
  #   end
  # end

  # def escape(terms)
  #   terms.map do |term|
  #     term.gsub /[\-]/ do |m|
  #       '\\' + m
  #     end
  #     # + - && || ! ( ) { } [ ] ^ ~ * ? : \ /
  #   end
  # end

  # def wildcardize(tokens)
  #   tokens.map do |term|
  #     "*#{term}*"
  #   end
  # end

  # def to_array(value)
  #   value.is_a?(Array) ? value : [value]
  # end

  # def prefix_indices(names)
  #   names.map do |n|
  #     # sometimes we get index names from search results where they are already
  #     # prefixed
  #     n.match(/^#{config['prefix']}/) ?
  #       n :
  #       "#{config['prefix']}-#{n}"
  #   end
  # end

  # def self.fetch(*args)
  #   if @cache.is_a?(Hash)
  #     key = args.map(&:to_s).join('.')
  #     @cache[key] ||= yield
  #   else
  #     yield
  #   end
  # end

  # def handle(response)
  #   if response.first == 200
  #     # JSON.pretty_generate(response)
  #     response
  #   else
  #     p response
  #     response
  #   end
  # end

end