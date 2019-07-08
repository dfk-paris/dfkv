wApp.i18n = {
  mixin: {
    t: (object) ->
      result = []
      for l in ['de', 'fr', 'en']
        result.push(object[l]) if object[l]
      result.join(' / ')
    tDe: (object) ->
      object['de'] || object['fr'] || object['en']
  }
}
