import {Url} from '@wendig/lib'
import Items from './items'
import Item from './item'

import {bus} from './bus'

class Search {
  static search(criteria) {
    const url = Url.parse(`${apiUrl}/search`)
    url.updateParams(criteria)

    fetch(url.url()).then(r => r.json()).then(data => {
      const items = new Items(data)
      bus.emit('search-results', items)
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
