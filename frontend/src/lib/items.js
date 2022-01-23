import Item from './item'

export default class Items {
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
      this.itemCache = this.hits().map((e, i) => new Item(e))
    }

    return this.itemCache
  }
}
