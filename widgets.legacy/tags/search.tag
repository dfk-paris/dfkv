<dfkv-search>
  <form if={data} onsubmit={submit}>
    <h2>Suchkriterien</h2>
    <input placeholder="Suche" onchange={search} value={initialTerms} ref="terms" />
    <!-- a href="#" onclick={newCriteria({terms: null})}>x</a -->

    <div if={person || attrib || journal || volume || rubric || location || editor}>
      <h2>Aktive Filter</h2>

      <ul>
        <li if={person && role}>
          <a
            onclick={newCriteria({person: null, role: null})}
            href="#"
            class="dfkv-filter"
          >
            {tDe(role)}:
            {person.display_name}
          </a>
        </li>
        <li if={attrib}>
          <a
            onclick={newCriteria({attrib: null})}
            href="#"
            class="dfkv-filter"
          >{tDe(attrib)}</a>
        </li>
        <li if={journal}>
          <a
            onclick={newCriteria({journal: null})}
            href="#"
            class="dfkv-filter"
          >{tDe(journal)}</a>
        </li>
        <li if={volume}>
          <a
            onclick={newCriteria({volume: null})}
            href="#"
            class="dfkv-filter"
          >{tDe(volume)}</a>
        </li>
        <li if={rubric}>
          <a
            onclick={newCriteria({rubric: null})}
            href="#"
            class="dfkv-filter"
          >{tDe(rubric)}</a>
        </li>
        <li if={location}>
          <a
            onclick={newCriteria({location: null})}
            href="#"
            class="dfkv-filter"
          >{tDe(location)}</a>
        </li>
        <li if={editor}>
          <a
            onclick={newCriteria({editor: null})}
            href="#"
            class="dfkv-filter"
          >{tDe(editor)}</a>
        </li>
      </ul>
    </div>
  </form>

  <div class="dfkv-results" if={data}>
    <h2>Suchergebnisse</h2>
    <virtual if={data.total == 0}>keine Ergebnisse</virtual>
    <virtual if={data.total > 0}>
      <div class="controls">
        <label class="dfkv-collapsing">
          alle ausklappen
          <input type="checkbox" onchange={toggle} />
        </label>
        <div class="dfkv-sorting">
          Sortieren nach: 
          <a href="#" onclick={sort('title')}>Titel</a> |
          <a href="#" onclick={sort('date')}>Datum</a>
        </div>
        <dfkv-pagination data={data} />
      </div>

      <hr />

      <dfkv-result
        each={result in data.records}
        data={result}
        always-expand={expand}
      />
    </virtual>
  </div>

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
      var terms = jQuery(event.target).val();
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

    tag.submit = function(event) {
      event.preventDefault();
    }

    tag.toggle = function(event) {
      var v = jQuery(event.target).prop('checked');
      tag.expand = v;
      tag.update();
      console.log(v);
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
      jQuery.ajax({
        url: tag.opts.url + '/people/' + id,
        success: function(data) {
          console.log(data);
          tag.person = data;
          tag.update();
        }
      })
    }

    var attrib = function(id, target) {
      jQuery.ajax({
        url: tag.opts.url + '/attribs/' + id,
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

      jQuery.ajax({
        url: tag.opts.url + '/search',
        data: params,
        success: function(data) {
          console.log(data);
          tag.data = data;
          tag.update();

          jQuery(tag.refs.terms).val(params['terms']);
        }
      })
    }
  </script>
</dfkv-search>