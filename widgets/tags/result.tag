<dfkv-result>
  <div class="expand-collapse">
    <a if={!isExpanded()} href="#" onclick={toggle}>… mehr</a>
    <a if={isExpanded() && !opts.alwaysExpand} href="#" onclick={toggle}>… weniger</a>
  </div>

  <div class="dfkv-muted">Id {opts.data.id}</div>

  <div>
    <strong>Title</strong>
    <dfkv-highlight
      contents={opts.data.title}
      terms={terms()}
    />
  </div>

  <div>
    <strong>Erschienen in</strong>
    <a
      if={opts.data.journal}
      href="#"
      onclick={only('journal', opts.data.journal.id)}
    >{tDe(opts.data.journal)}</a><!--
    --><span
      if={opts.data.volume}
    >, 
      <a
        href="#"
        onclick={only('volume', opts.data.volume.id)}
        class="dfkv-italic"
      >{tDe(opts.data.volume)}</a>
    </span><!--
    --><span
      if={opts.data.location}
    ><!--
      --><virtual if={opts.data.journal}>, </virtual><!--
      --><a
        href="#"
        onclick={only('location', opts.data.location.id)}
        class="dfkv-bold"
      >{tDe(opts.data.location)}</a>
    </span>
  </div>

  <div>
    <strong>Datum</strong>
    <span>{opts.data.human_date}</span>
  </div>

  <div class="dfkv-longread {hidden: !isExpanded()}">
    <div if={opts.data.rubric}>
      <strong>Rubrik</strong>
      <span>
        <a href="#" onclick={only('rubric', opts.data.rubric.id)}>
          {tDe(opts.data.rubric)}
        </a>
      </span>
    </div>

    <div if={opts.data.editor}>
      <strong>Verlag</strong>
      <span>
        <a href="#" onclick={only('editor', opts.data.editor.id)}>
          {tDe(opts.data.editor)}
        </a>
      </span>
    </div>

    <p if={opts.data.citation}>
      <dfkv-highlight
        contents={opts.data.citation}
        terms={terms()}
      />
    </p>

    <p if={opts.data.transcription} class="dfkv-italic">
      <dfkv-highlight
        contents={opts.data.transcription}
        terms={terms()}
      />
    </p>

    <div if={opts.data.comment}>
      <strong>Kommentar</strong>
      <blockquote>
        <dfkv-highlight
          contents={opts.data.comment}
          terms={terms()}
        />
      </blockquote>
    </div>

    <div
      each={people, role_id in opts.data.people_by_role.people}
      data-id={role_id}
    >
      <strong>{tDe(opts.data.people_by_role.roles[role_id])}</strong>
      <span
        each={person in people}
        class="dfkv-badge"
        data-id={person.id}
      >
        <a href="#" onclick={onlyPerson(role_id, person.id)}>
          {person.display_name}
        </a>
      </span>
    </div>

    <div if={opts.data.attribs_by_kind.attribs[42]}>
      <strong>{tDe(opts.data.attribs_by_kind.kinds[42])}</strong>
      <span
        each={a in opts.data.attribs_by_kind.attribs[42]}
        class="dfkv-badge"
        data-id={a.id}
      >
        <a href="#" onclick={only('attrib', a.id)}>{tDe(a)}</a>
      </span>
    </div>

    <div if={opts.data.attribs_by_kind.attribs[43]}>
      <strong>Schlagwörter</strong>
      <span
        each={a in opts.data.attribs_by_kind.attribs[43]}
        class="dfkv-badge"
        data-id={a.id}
      >
        <a href="#" onclick={only('attrib', a.id)}>{tDe(a)}</a>
      </span>
    </div>
  </div>

  <script type="text/javascript">
    var tag = this;
    tag.mixin(wApp.i18n.mixin);

    tag.onlyPerson = function(role_id, person_id) {
      return function(event) {
        event.preventDefault();
        wApp.bus.trigger('dfkv:criteria', {role: role_id, person: person_id});
      }
    }

    tag.only = function(type, id) {
      return function(event) {
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
      console.log(tag.opts.alwaysExpand);
      return tag.expanded || tag.opts.alwaysExpand
    }

    tag.toggle = function(event) {
      event.preventDefault();
      tag.expanded = !tag.expanded;
    }
  </script>
</dfkv-result>