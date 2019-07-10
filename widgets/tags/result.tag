<dfkv-result>
  <div class="dfkv-inner" onclick={toggle}>
    <div class="dfkv-pull-right dfkv-muted dfkv-id">
      id <a href="#" onclick={only('terms', opts.data.id)}>{opts.data.id}</a>
    </div>

    <div class="dfkv-creator" if={opts.data.people_by_role.people[12063]}>
      <span
        each={person, i in opts.data.people_by_role.people[12063]}
        data-id={person.id}
      ><!--
     --><virtual if={i > 0}>; </virtual><!--
     --><a href="#" onclick={onlyPerson(12063, person.id)}>{person.display_name}</a><!--
   --></span>
    </div>


    <dfkv-highlight
      contents={opts.data.title}
      terms={terms()}
      class="dfkv-title"
    />

    <div class="dfkv-published-in">
      <a
        if={opts.data.journal}
        href="#"
        onclick={only('journal', opts.data.journal.id)}
        class="dfkv-journal"
      >{tDe(opts.data.journal)}</a><!--
   --><virtual if={opts.data.volume}><!--
     -->, 
        <a
          href="#"
          onclick={only('volume', opts.data.volume.id)}
          class="dfkv-volume"
        >{tDe(opts.data.volume)}</a><!--
   --></virtual><!--
   --><virtual if={opts.data.location}><!--
     --><virtual if={opts.data.journal}>, </virtual><!--
     --><a
          href="#"
          onclick={only('location', opts.data.location.id)}
          class="dfkv-location"
        >{tDe(opts.data.location)}</a><!--
   --></virtual><!--
   --><span if={opts.data.date} class="dfkv-date">, {opts.data.human_date}</span>
    </div>

    <div class="dfkv-longread {hidden: !isExpanded()}">
      <p if={opts.data.citation} class="dfkv-text">
        <dfkv-highlight
          contents={opts.data.citation}
          terms={terms()}
        />
      </p>

      <p if={opts.data.transcription} class="dfkv-text dfkv-italic">
        <dfkv-highlight
          contents={opts.data.transcription}
          terms={terms()}
        />
      </p>

      <div if={opts.data.comment}>
        <strong>Kommentar</strong>
        <p class="dfkv-text">
          <dfkv-highlight
            contents={opts.data.comment}
            terms={terms()}
          />
        </p>
      </div>

      <div if={opts.data.editor} class="dfkv-editor">
        <h2>Verlag</h2>
        <span>
          <a href="#" onclick={only('editor', opts.data.editor.id)}>
            {tDe(opts.data.editor)}
          </a>
        </span>
      </div>

      <div if={opts.data.rubric} class="dfkv-rubric">
        <h2>Rubrik</h2>
        <span>
          <a href="#" onclick={only('rubric', opts.data.rubric.id)}>
            {tDe(opts.data.rubric)}
          </a>
        </span>
      </div>

      <div class="dfkv-people">
        <h2>Weitere beteiligte Personen</h2>
        <span
          each={person, i in opts.data.people_by_role.people[12069]}
          data-id={person.id}
        ><!--
       --><virtual if={i > 0}>; </virtual><!--
       --><a href="#" onclick={onlyPerson(12069, person.id)}>{person.display_name}</a>
          (Übersetzer)<!--
     --></span><!--
       --><virtual if={hasAnyRoles(12069)}>; </virtual><!--
     --><span
          each={person, i in opts.data.people_by_role.people[12065]}
          data-id={person.id}
        ><!--
       --><virtual if={i > 0}>; </virtual><!--
       --><a href="#" onclick={onlyPerson(12065, person.id)}>{person.display_name}</a>
          (abgebildet)<!--
     --></span><!--
       --><virtual if={hasAnyRoles(12065)}>; </virtual><!--
     --><span
          each={person, i in opts.data.people_by_role.people[12064]}
          data-id={person.id}
        ><!--
       --><virtual if={i > 0}>; </virtual><!--
       --><a href="#" onclick={onlyPerson(12064, person.id)}>{person.display_name}</a><!--
     --></span>
      </div>

      <div if={opts.data.attribs_by_kind.attribs[42]} class="dfkv-attribs">
        <h2>{tDe(opts.data.attribs_by_kind.kinds[42])}</h2>
        <span
          each={a, i in opts.data.attribs_by_kind.attribs[42]}
          data-id={a.id}
        ><!--
       --><virtual if={i > 0}>, </virtual><!--
       --><a href="#" onclick={only('attrib', a.id)}>{tDe(a)}</a><!--
     --></span>
      </div>

      <div if={opts.data.attribs_by_kind.attribs[43]} class="dfkv-attribs">
        <h2>Schlagwörter</h2>
        <span
          each={a, i in opts.data.attribs_by_kind.attribs[43]}
          data-id={a.id}
        ><!--
       --><virtual if={i > 0}>, </virtual><!--
       --><a href="#" onclick={only('attrib', a.id)}>{tDe(a)}</a><!--
     --></span>
      </div>
    </div>
  </div>

  <script type="text/javascript">
    var tag = this;
    tag.mixin(wApp.i18n.mixin);

    tag.onlyPerson = function(role_id, person_id) {
      return function(event) {
        event.stopPropagation();
        event.preventDefault();
        wApp.bus.trigger('dfkv:criteria', {role: role_id, person: person_id});
      }
    }

    tag.only = function(type, id) {
      return function(event) {
        event.stopPropagation();
        event.preventDefault();
        var args = {}
        args[type] = id;
        wApp.bus.trigger('dfkv:criteria', args);
      }
    }

    tag.terms = function() {
      return wApp.routing.query()['terms'];
    }

    tag.isExpanded = function() {
      return tag.expanded || tag.opts.alwaysExpand;
    }

    tag.toggle = function(event) {
      event.preventDefault();
      tag.expanded = !tag.expanded;
    }

    tag.hasAnyRoles = function() {
      var roles = arguments;
      for (var i = 0; i < roles.length; i++) {
        var id = roles[i];
        if (opts.data.people_by_role.people[id]) {return true;}
      }
      return false;
    }
  </script>
</dfkv-result>