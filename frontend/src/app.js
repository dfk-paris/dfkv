import './app.scss'

import * as riot from 'riot'
import {bus, BusRiotPlugin} from './lib/bus'
import {i18n, RiotPlugins} from '@wendig/lib'
import Search from './components/search.riot'

i18n.fetch('/translations.json').then(() => {
  i18n.setLocale('de')

  RiotPlugins.setup(riot)
  riot.install(RiotPlugins.parent)
  riot.install(BusRiotPlugin)

  riot.register('dfkv', Search)
  riot.mount('[is]')

  console.log('mounting complete!')
})
