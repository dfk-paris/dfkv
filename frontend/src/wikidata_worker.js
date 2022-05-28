import Database from './lib/database/database'
import {util} from '@wendig/lib'

import records from '../../data/entities.js'

const db = new Database()
onmessage = db.handler

let storage = {}

db.action('register', (data) => {
  const results = storage.register[data.letter] || []

  return {
    letter: data.letter,
    records: results.slice(0, 20)
  }
})

// db.action('lookup', (data) => {
//   const id = data.id

//   for (const record of storage['records']) {
//     const match =
//       (record['wikidata_id'] == id) ||
//       (record['dfk_id'] == id) ||
//       (record['or_id'] == id) ||
//       (record['pb_id'] == id)

//     if (match) {
//       return {record: record}
//     }
//   }

//   return {}
// })

db.action('query', (data) => {
  let results = storage['records']

  const c = data.criteria
  const terms = util.fold(c['terms'])

  results = results.filter(record => {
    if (terms) {
      const q = util.fold(record['wikidata_id'] || '')
      const id_match = !!q.match(new RegExp(terms))

      const l = util.fold(record['label'] || '')
      const label_match = !!l.match(new RegExp(terms))

      if (!id_match && !label_match) {
        return false
      }
    }

    return true
  })

  // aggregate
  const refs = {}
  const letters = {}
  for (const record of results) {
    for (const ref of ['or', 'dfkv', 'pb', 'wikidata']) {
      const id = record[`${ref}_id`]
      if (id) {
        refs[ref] = refs[ref] || 0
        refs[ref] += 1
      }
    }

    const l = record['letter']
    letters[l] = letters[l] || 0
    letters[l] += 1
  }

  // filter
  results = results.filter(record => {
    if (c['letter']) {
      if (c['letter'] != record['letter']) {
        return false
      }
    }

    return true
  })


  // paginate
  const total = results.length
  const perPage = 20
  const page = parseInt(c['page'] || '1')
  results = results.slice((page - 1) * perPage, page * perPage)

  const response = {
    page,
    total,
    results,
    terms,
    aggs: {refs, letters}
  }
  
  console.log(response)
  return response
})

db.action('counts', (data) => {
  return {
    wikidata: storage.wikidataCount,
    noRef: storage.records.length
  }
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
  storage['wikidataCount'] = countWikidata(storage['records'])

  console.log(storage)
  db.loaded()
}

const enrich = (records) => {
  return records.map(record => {
    // calc label
    record['label'] = 
      record['label'] ||
      record['dfkv_label'] ||
      record['or_label'] ||
      record['pb_label']

    // compile refs
    record['refs'] = {}
    for (const k of ['or', 'pb', 'dfkv']) {
      const v = record[`${k}_id`]
      if (v) {
        record['refs'][k] = v
      }
    }

    // calc first letter
    record['letter'] = letterFor(record)

    return record
  })
}

const letterFor = (record) => {
  if (!record['label']) {return '?'}

  const lower = record['label'][0].toLowerCase()
  return util.fold(lower)
}

const countWikidata = (data) => {
  let result = 0

  for (const record of data) {
    if (record['wikidata_id']) {
      result += 1
    }
  }

  return result
}

const toRegister = (data) => {
  const results = {}

  for (const record of data) {
    record['label'] = 
      record['label'] ||
      record['dfkv_label'] ||
      record['or_label'] ||
      record['pb_label']

    const letter = util.fold((record['label'] || '')[0])

    results[letter] = results[letter] || []
    results[letter].push(record)
  }

  return results
}
