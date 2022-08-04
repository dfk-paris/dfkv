import './standalone.scss'

import * as riot from 'riot'
import {bus, BusRiotPlugin} from './lib/bus'
import {i18n, RiotPlugins} from '@wendig/lib'

import WikidataLoading from './components/wikidata/loading.riot'
import WikidataEntities from './components/wikidata/wikidata_entities.riot'
import WikidataChart from './components/wikidata/chart.riot'

// import FlyIn from '@dfk-paris/dfkv/frontend/src/components/fly_in.riot'

i18n.fetch(`${staticUrl}/translations.json`).then(() => {
  i18n.setLocale('de')
  i18n.setFallbacks(['fr', 'de', 'en'])

  RiotPlugins.setup(riot)
  riot.install(RiotPlugins.i18n)
  riot.install(RiotPlugins.parent)
  riot.install(RiotPlugins.setTitle)
  riot.install(BusRiotPlugin)

  riot.register('wikidata-loading', WikidataLoading)
  riot.register('wikidata-entities', WikidataEntities)
  riot.register('wikidata-chart', WikidataChart)

  riot.mount('[is]')

  console.log('mounting complete!')
})
