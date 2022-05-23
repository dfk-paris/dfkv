require 'json'

class Dfkv::Server
  def self.call(env)
    new.call(env)
  end

  def call(env)
    @env = env
    route
  end

  def request
    @request ||= Rack::Request.new(@env)
  end

  def route
    p request.path_info, request.params

    case request.path_info
      when /^\/search$/ then search
      when /^\/records\/(\d+)$/ then record($1.to_i)
      else
        render JSON.dump(message: 'not found'), status: 404
    end
  end

  def search
    results = elastic.search(search_params)

    render JSON.dump(results)
  end

  def record(id)
    result = elastic.find(id)

    render JSON.dump(result)
  end


  protected

    def search_params
      return {
        'page' => page,
        'per_page' => per_page,
        'terms' => terms,
        'id' => to_ids(request.params['id']),
        'from' => request.params['from'],
        'to' => request.params['to'],
        'project_id' => request.params['project'],
        'creator' => request.params['creator'],
        'involved' => request.params['involved'],
        'journal' => request.params['journal'],
        'type' => request.params['type'],
        'sort' => sort,
        'direction' => direction
      }
    end

    def elastic
      @elastic = Dfkv::Elastic.new
    end

    def to_ids(string)
      (string || '').split(/\s*,\s*/).map{|e| e.to_i}
    end

    def terms
      request.params['terms']
    end

    def page
      (request.params['page'] || 1).to_i
    end

    def per_page
      (request.params['per_page'] || 10).to_i
    end

    def sort
      request.params['sort'] || 'creator'
    end

    def direction
      request.params['direction'] || 'asc'
    end

    def render(body = nil, options = {})
      options = {
        status: 200,
        content_type: 'application/json'
      }.merge(options)

      headers = {
        'content-type' => options[:content_type]
      }
      body = (body == nil ? [] : [body])
      [options[:status], headers, body]
    end
end
