import './standalone.scss'

import * as riot from 'riot'
import {bus, BusRiotPlugin} from './lib/bus'
import {i18n, RiotPlugins} from '@wendig/lib'

import Search from './components/dfkv/search.riot'
import WatchlistTrigger from './components/dfkv/watchlist_trigger.riot'
import WikidataEntities from './components/wikidata/wikidata_entities.riot'

i18n.fetch(`${staticUrl}/translations.json`).then(() => {
  i18n.setLocale('de')
  i18n.setFallbacks(['fr', 'de', 'en'])

  RiotPlugins.setup(riot)
  riot.install(RiotPlugins.i18n)
  riot.install(RiotPlugins.parent)
  riot.install(RiotPlugins.setTitle)
  riot.install(BusRiotPlugin)

  riot.register('dfkv', Search)
  riot.register('wikidata-entities', WikidataEntities)
  riot.register('dfkv-watchlist-trigger', WatchlistTrigger)

  riot.mount('[is]')

  console.log('mounting complete!')
})
