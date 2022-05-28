import Item from '../item'
import {baseUrl} from '../../lib/util'

let messageId = 10000
let instanceRegistry = []

const worker = new Worker(baseUrl + '/wikidata_worker.js', {credentials: 'same-origin'})
worker.onmessage = event => {
  for (const instance of instanceRegistry) {
    instance.onResponse(event)
  }
}

class Search {
  constructor() {
    instanceRegistry.push(this)

    // this.listeners = {}
    this.resolveMap = {}
  }

  destruct() {
    const index = instanceRegistry.indexOf(this)
    if (index != -1) {
      instanceRegistry.splice(index, 1)
    }
  }

  onResponse(event) {
    const data = event.data
    // const action = data.action
    // const listeners = this.listeners[action] || []

    // for (const l of listeners) {
      // l(data)
    // }

    const resolve = this.resolveMap[data.messageId]
    if (resolve) {
      delete this.resolveMap[data.messageId]
      resolve(data)
    }
  }

  counts() {
    return this.postMessage({action: 'counts'})
  }

  // register(initial) {
  //   return this.postMessage({action: 'register', initial: initial})
  // }

  query(criteria) {
    return this.postMessage({action: 'query', criteria})
  }

  // lookup(id) {
  //   return this.postMessage({action: 'lookup', id: id})
  // }

  postMessage(data) {
    const newId = messageId
    messageId += 1

    const promise = new Promise((resolve, reject) => {
      this.resolveMap[newId] = resolve

      data.messageId = newId
      worker.postMessage(data)
    })

    return promise
  }
}

const search = new Search()

export default search
