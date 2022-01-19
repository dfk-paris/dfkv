import {Url} from '@wendig/lib'
import Item from './item'

import {bus} from './bus'

class Items {
  constructor(data) {
    this.data = data
  }

  total() {
    return this.data['hits']['total']['value']
  }

  aggregations() {
    return this.data['aggregations']
  }

  hits() {
    return this.data['hits']['hits']
  }

  items() {
    if (!this.itemCache) {
      this.itemCache = this.hits().map(e => new Item(e))
    }

    return this.itemCache
  }
}

class Search {
  static search(criteria) {
    const url = Url.parse('http://localhost:3001/search')
    url.updateParams(criteria)

    fetch(url.url()).then(r => r.json()).then(data => {
      const items = new Items(data)
      console.log(items)
      bus.emit('search-results', items)
    })
  }

  static findRecord(id) {
    const url = `http://localhost:3001/records/${id}`
    return fetch(url).
      then(r => r.json()).
      then(data => new Item(data))
  }
}

export default Search
