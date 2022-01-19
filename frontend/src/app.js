import './app.scss'

import * as riot from 'riot'
import {bus, BusRiotPlugin} from './lib/bus'
import {i18n, RiotPlugins} from '@wendig/lib'

import FlyIn from './components/dfkv/fly_in.riot'
import RoutedModal from './components/dfkv/routed_modal.riot'
import Search from './components/dfkv/search.riot'
import WatchlistTrigger from './components/dfkv/watchlist_trigger.riot'

i18n.fetch('/translations.json').then(() => {
  i18n.setLocale('de')

  RiotPlugins.setup(riot)
  riot.install(RiotPlugins.i18n)
  riot.install(RiotPlugins.parent)
  riot.install(BusRiotPlugin)

  riot.register('dfkv', Search)
  riot.register('dfkv-fly-in', FlyIn)
  riot.register('dfkv-watchlist-trigger', WatchlistTrigger)
  riot.register('dfkv-routed-modal', RoutedModal)

  riot.mount('[is]')

  console.log('mounting complete!')
})
