import {Url} from '@wendig/lib'
import Items from './items'
import Item from './item'

import {bus} from './bus'

class Search {
  static fetch(criteria) {
    const url = Url.parse(`${apiUrl}/search`)
    url.updateParams(criteria)

    return fetch(url.url()).
      then(r => r.json()).
      then(data => new Items(data))
  }

  static search(criteria) {
    Search.fetch(criteria).then(items => {
      bus.emit('search-results', items)
      bus.emit('search-criteria', criteria)
    })
  }

  static findRecord(id) {
    const url = `${apiUrl}/records/${id}`
    return fetch(url).
      then(r => r.json()).
      then(data => new Item(data))
  }
}

export default Search
