<dfkv-pagination>
  <virtual if={opts.data && total_pages() > 1}>
    <a
      show={!is_first()}
      onclick={page_to_first}
      href="#"
      class="dfkv-first"
    ><dfkv-svg type="arrow-left" /><dfkv-svg type="arrow-left" /> erste Seite</a>
    <a
      show={!is_first()}
      onclick={page_down}
      href="#"
      class="dfkv-previous"
    ><dfkv-svg type="arrow-left" /> vorherige Seite</a>
    {opts.data.page}/{total_pages()}
    <a
      show={!is_last()}
      onclick={page_up}
      href="#"
      class="dfkv-next"
    >nächste Seite<dfkv-svg type="arrow-right" /></a>
    <a
      show={!is_last()}
      onclick={page_to_last}
      href="#"
      class="dfkv-last"
    >letzte Seite <dfkv-svg type="arrow-right" /><dfkv-svg type="arrow-right" /></a>
  </virtual>

  <script type="text/coffee">
    tag = this

    tag.current_page = -> tag.opts.data.page
    tag.page_to_first = (event) ->
      event.preventDefault()
      tag.page_to(1)
    tag.page_down = (event) ->
      event.preventDefault()
      tag.page_to(tag.current_page() - 1)
    tag.page_up = (event) ->
      event.preventDefault()
      tag.page_to(tag.current_page() + 1)
    tag.page_to_last = (event) ->
      event.preventDefault()
      tag.page_to(tag.total_pages())

    tag.is_first = -> tag.current_page() == 1
    tag.is_last = -> tag.current_page() == tag.total_pages()

    tag.page_to = (new_page) ->
      if new_page != tag.current_page() && new_page >= 1 && new_page <= tag.total_pages()
        wApp.routing.query page: new_page

    tag.total_pages = ->
      Math.ceil(tag.opts.data.total / tag.opts.data.per_page)
  </script>
</dfkv-pagination>