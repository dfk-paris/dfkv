<dfkv-pagination>
  <div class="w-text-right" if={opts.data && total_pages() > 1}>
    <a
      show={!is_first()}
      onclick={page_to_first}
      href="#"
    >«</i></a>
    <a
      show={!is_first()}
      onclick={page_down}
      href="#"
    >‹</a>
    {opts.data.page}/{total_pages()}
    <a
      show={!is_last()}
      onclick={page_up}
      href="#"
    >›</a>
    <a
      show={!is_last()}
      onclick={page_to_last}
      href="#"
    >»</a>
  </div>

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