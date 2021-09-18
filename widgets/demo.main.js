import 'regenerator-runtime/runtime'

import * as riot from 'riot'
import RiotTagsPlugin from './lib/riot_tags'
import Demo from './components/demo.riot'

riot.install(RiotTagsPlugin)
riot.register('dfk-demo', Demo)
riot.mount('[is]')

console.log('mounting complete!')
