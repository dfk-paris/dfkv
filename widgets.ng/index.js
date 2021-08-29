import 'regenerator-runtime/runtime'

import * as riot from 'riot'
import App from './components/app.riot'

const mountApp = riot.component(App)
const element = document.getElementById('root')
const app = mountApp(element, {value: 'stuff'})
