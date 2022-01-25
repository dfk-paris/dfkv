import {Url} from '@wendig/lib'
import Items from './items'
import Item from './item'

import {bus} from './bus'
import env from './env'

class Search {
  static apiUrl() {
    return env['env-api-url']
  }

  static search(criteria) {
    const url = Url.parse(`${Search.apiUrl()}/search`)
    url.updateParams(criteria)

    fetch(url.url()).then(r => r.json()).then(data => {
      const items = new Items(data)
      bus.emit('search-results', items)
    })
  }

  static findRecord(id) {
    console.log(url, 'x')
    const url = `${Search.apiUrl()}/records/${id}`
    return fetch(url).
      then(r => r.json()).
      then(data => new Item(data))
  }
}

export default Search
