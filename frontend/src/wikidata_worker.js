import Database from './lib/database/database'
import {util} from '@wendig/lib'

import records from '../../data/entities.js'

const db = new Database()
onmessage = db.handler

let storage = {}

db.action('register', (data) => {
  return {
    initial: data.initial,
    records: storage.register[data.initial] || []
  }
})

db.action('lookup', (data) => {
  const id = data.id

  for (const record of storage['records']) {
    const match =
      (record['wikidata_id'] == id) ||
      (record['dfk_id'] == id) ||
      (record['or_id'] == id) ||
      (record['pb_id'] == id)

    if (match) {
      return {record: record}
    }
  }

  return {}
})

// const rootUrl = () => {
//   const u = `${location.href}`
//   return u.replace(/\/wikidata_worker\.js/, '')
// }
// const promise = fetch(`${rootUrl()}/data/entities.json`).
//   then(response => response.json()).
//   then(data => {
//     storage['entities'] = data
//     console.log(`loaded entities`)

//     ready = true
//     for (const job of queue) {
//       handler(job)
//     }
//     queue = []
//   })

setTimeout(() => {init()}, 0)


// functions

const init = () => {
  storage['records'] = enrich(records)
  storage['register'] = toRegister(storage['records'])

  console.log(storage)
  db.loaded()
}

const enrich = (records) => {
  return records.map(record => {
    record['refs'] = {}

    for (const k of ['dfk', 'or', 'pb', 'wikidata', 'dfkv']) {
      const v = record[`${k}_id`]
      if (v) {
        record['refs'][k] = v
      }
    }

    return record
  })
}

const toRegister = (data) => {
  const results = {}

  for (const record of data) {
    record['label'] = 
      record['label'] ||
      record['dfkv_label'] ||
      record['or_label'] ||
      record['pb_label']

    const initial = util.fold((record['label'] || '')[0])

    results[initial] = results[initial] || []
    results[initial].push(record)
  }

  return results
}
