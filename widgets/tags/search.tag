<dfkv-search>
  <div class="header" if={data}>
    <h3>Search</h3>
    <input placeholder="search" onchange={search} value={initialTerms} ref="terms" />
    <a href="#" onclick={newCriteria({terms: null})}>x</a>

    <h3>Filters</h3>
    <a 
      if={person && role}
      onclick={newCriteria({person: null, role: null})}
      href="#"
      class="filter"
    >
      {t(role)}:
      {person.display_name}
    </a>
    <a
      if={attrib}
      onclick={newCriteria({attrib: null})}
      href="#"
      class="filter"
    >{t(attrib)}</a>
    <a
      if={journal}
      onclick={newCriteria({journal: null})}
      href="#"
      class="filter"
    >{t(journal)}</a>
    <a
      if={volume}
      onclick={newCriteria({volume: null})}
      href="#"
      class="filter"
    >{t(volume)}</a>
    <a
      if={rubric}
      onclick={newCriteria({rubric: null})}
      href="#"
      class="filter"
    >{t(rubric)}</a>
    <a
      if={location}
      onclick={newCriteria({location: null})}
      href="#"
      class="filter"
    >{t(location)}</a>
    <a
      if={editor}
      onclick={newCriteria({editor: null})}
      href="#"
      class="filter"
    >{t(editor)}</a>

    <h3>Sort</h3>
    <a href="#" onclick={sort('title')}>Title</a>
    <a href="#" onclick={sort('date')}>Date</a>

    <h3>Pagination</h3>
    <dfkv-pagination data={data} />
  </div>

  <hr /><hr />

  <virtual if={data}>
    <dfkv-result each={result in data.records} data={result} />
  </virtual>

  <script type="text/javascript">
    var tag = this;
    tag.mixin(wApp.i18n.mixin);

    tag.on('mount', function() {
      tag.initialTerms = wApp.routing.query()['terms'];

      wApp.bus.on('routing:query', search);
      wApp.bus.on('dfkv:criteria', newCriteria);
      search();
    })

    tag.search = function(event) {
      var terms = $(event.target).val();
      newCriteria({'terms': terms});
    }

    tag.sort = function(field) {
      return function(event) {
        event.preventDefault();

        var s = wApp.routing.query()['sort'] || 'title';
        var d = wApp.routing.query()['direction'] || 'asc';

        var params = {}
        if (s == field) {
          newCriteria({
            'direction': (d == 'asc' ? 'desc' : 'asc'),
            'page': null
          });
        } else {
          newCriteria({
            'sort': field,
            'direction': 'asc',
            'page': null
          });
        }
      }
    }

    tag.newCriteria = function(criteria) {
      return function(event) {
        event.preventDefault();
        newCriteria(criteria);
      }
    }

    var newCriteria = function(criteria) {
      var current = wApp.routing.query();
      for (var k in criteria) {
        if (criteria[k] !== current[k]) {
          criteria['page'] = 1;
          break;
        }
      }

      wApp.routing.query(criteria);
    }

    var person = function(id) {
      $.ajax({
        url: 'http://127.0.0.1:3001/people/' + id,
        success: function(data) {
          console.log(data);
          tag.person = data;
          tag.update();
        }
      })
    }

    var attrib = function(id, target) {
      $.ajax({
        url: 'http://127.0.0.1:3001/attribs/' + id,
        success: function(data) {
          console.log(data);
          tag[target] = data;
          tag.update();
        }
      })
    }

    var search = function() {
      var params = wApp.routing.query();
      console.log(params);

      tag.person = null;
      if (params['person']) {person(params['person'])}

      var fields = [
        'role', 'attrib', 'journal', 'volume', 'rubric', 'location', 'editor'
      ];
      for (var i = 0; i < fields.length; i++) {
        var f = fields[i];
        tag[f] = null;
        if (params[f]) {attrib(params[f], f)}
      }

      // if (params['role']) {attrib(params['role'], 'role')}
      // if (params['attrib']) {attrib(params['attrib'], 'attrib')}
      // if (params['journal']) {attrib(params['journal'], 'journal')}
      // if (params['volume']) {attrib(params['volume'], 'volume')}
      // if (params['rubric']) {attrib(params['rubric'], 'rubric')}
      // if (params['location']) {attrib(params['location'], 'location')}
      // if (params['editor']) {attrib(params['editor'], 'editor')}

      $.ajax({
        url: 'http://127.0.0.1:3001/search',
        data: params,
        success: function(data) {
          console.log(data);
          tag.data = data;
          tag.update();

          $(tag.refs.terms).val(params['terms']);
        }
      })
    }
  </script>
</dfkv-search>