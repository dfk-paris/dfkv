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
      else
        render JSON.dump(message: 'not found'), status: 404
    end
  end

  def search
    results = elastic.search(
      'page' => page,
      'per_page' => per_page,
      'terms' => terms,
      'from' => request.params['from'],
      'to' => request.params['to'],
      'sort' => sort,
      'direction' => direction,
    )

    render JSON.dump(results)
  end

  def elastic
    @elastic = Dfkv::Elastic.new
  end

  # def person(id)
  #   @person = Dfkv::Person.find(id)
  #   render @person.to_json
  # end

  # def attrib(id)
  #   @attrib = Dfkv::Attrib.find(id)
  #   render @attrib.to_json
  # end

  # def search
  #   return render({dummy: true}.to_json)
    
    
  #   @records = Dfkv::Record.
  #     # includes(
  #     #   # :journal, :volume, :project, :rubric, :location, :editor,
  #     #   contributions: :person,
  #     #   attribs: :kind,
  #     # ).
  #     by_person(request.params['role'], request.params['person']).
  #     by_attrib(request.params['attrib']).
  #     by_journal(request.params['journal']).
  #     by_volume(request.params['volume']).
  #     by_rubric(request.params['rubric']).
  #     by_location(request.params['location']).
  #     by_editor(request.params['editor']).
  #     search(request.params['terms']).
  #     order(sort => direction)

  #   puts @records.to_sql

  #   now = Time.now
  #   result = {
  #     'total' => @records.count,
  #     'records' => @records.pageit(page, per_page).as_json(
  #       include: [:journal, :volume, :project, :rubric, :location, :editor],
  #       methods: [:people_by_role, :attribs_by_kind, :human_date]
  #     ),
  #     'per_page' => per_page,
  #     'page' => page
  #   }
  #   p Time.now - now

  #   render result.to_json
  # end

  def terms
    request.params['terms'] || '*'
  end

  def page
    (request.params['page'] || 1).to_i
  end

  def per_page
    (request.params['per_page'] || 10).to_i
  end

  def sort
    request.params['sort'] || 'title'
  end

  def direction
    request.params['direction'] || 'asc'
  end

  def render(body = nil, options = {})
    options = {
      status: 200,
      content_type: 'application/json'
    }.merge(options)

    body = (body == nil ? [] : [body])
    [options[:status], {'content-type' => options[:content_type]}, body]
  end
end
