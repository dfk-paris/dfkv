import './widgets.scss'

import * as riot from 'riot'
import {RiotPlugins} from '@wendig/lib'
import Widgets from './components/widgets/widgets.riot'

RiotPlugins.setup(riot)
riot.install(RiotPlugins.parent)

riot.register('dfk-widgets', Widgets)
riot.mount('[is]')

console.log('mounting complete!')
