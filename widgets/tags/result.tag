<dfkv-result>
  <div><strong>Title: </strong>{opts.data.title}</div>
  
  <div
    each={people, role_id in opts.data.people_by_role.people}
    data-id={role_id}
  >
    <strong>{t(opts.data.people_by_role.roles[role_id])}</strong>
    <span
      each={person in people}
      class="badge"
      data-id={person.id}
    >
      <a href="#" onclick={onlyPerson(role_id, person.id)}>
        {person.display_name}
      </a>
    </span>
  </div>

  <div if={opts.data.journal}>
    <strong>Zeitschrift</strong>
    <span>
      <a href="#" onclick={only('journal', opts.data.journal.id)}>
        {t(opts.data.journal)}
      </a>
    </span>
  </div>

  <div if={opts.data.volume}>
    <strong>Ausgabe</strong>
    <span>
      <a href="#" onclick={only('volume', opts.data.volume.id)}>
        {t(opts.data.volume)}
      </a>
    </span>
  </div>

  <strong>Datum</strong>
  <span>{opts.data.human_date}</span>

  <div if={opts.data.rubric}>
    <strong>Rubric</strong>
    <span>
      <a href="#" onclick={only('rubric', opts.data.rubric.id)}>
        {t(opts.data.rubric)}
      </a>
    </span>
  </div>

  <div if={opts.data.location}>
    <strong>Ort</strong>
    <span>
      <a href="#" onclick={only('location', opts.data.location.id)}>
        {t(opts.data.location)}
      </a>
    </span>
  </div>

  <div if={opts.data.editor}>
    <strong>Verlag</strong>
    <span>
      <a href="#" onclick={only('editor', opts.data.editor.id)}>
        {t(opts.data.editor)}
      </a>
    </span>
  </div>

  <div if={opts.data.citation}>
    <strong>Zitat</strong>
    <blockquote>{opts.data.citation}</blockquote>
  </div>

  <div if={opts.data.transcription}>
    <strong>Transkription</strong>
    <blockquote>{opts.data.transcription}</blockquote>
  </div>

  <div if={opts.data.comment}>
    <strong>Kommentar</strong>
    <blockquote>{opts.data.transcription}</blockquote>
  </div>

  <div if={opts.data.attribs_by_kind.attribs[42]}>
    <strong>{t(opts.data.attribs_by_kind.kinds[42])}</strong>
    <span
      each={a in opts.data.attribs_by_kind.attribs[42]}
      class="badge"
      data-id={a.id}
    >
      <a href="#" onclick={only('attrib', a.id)}>{t(a)}</a>
    </span>
  </div>

  <div if={opts.data.attribs_by_kind.attribs[43]}>
    <strong>{t(opts.data.attribs_by_kind.kinds[43])}</strong>
    <span
      each={a in opts.data.attribs_by_kind.attribs[43]}
      class="badge"
      data-id={a.id}
    >
      <a href="#" onclick={only('attrib', a.id)}>{t(a)}</a>
    </span>
  </div>



  <hr />

  <style type="text/css">
    dfkv-result {
      display: block;
    }
  </style>

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
  </script>
</dfkv-result>