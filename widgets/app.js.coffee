wApp = {
  setup: ->
    wApp.routing.setup()
    riot.mount('dfkv-search')
  locale: ->
    if m = wApp.routing.path().match(/^\/(en|de|fr)\//)
      m[1]
    else
      wApp.routing.query()['locale'] || 'de'
  bus: riot.observable()
}
