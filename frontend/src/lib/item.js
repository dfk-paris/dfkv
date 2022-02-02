import {i18n} from '@wendig/lib'

const l = i18n.localize

export default class Item {
  constructor(data) {
    this.data = data
  }

  id() {
    return this.data['_source']['id']
  }

  title() {
    return this.data['_source']['title']
  }

  citation() {
    return this.data['_source']['citation']
  }

  transcription() {
    return this.data['_source']['transcription']
  }

  imageUrl() {
    return 'https://ownreality.dfkg.org/files/e4044e9aa708504f9b473d14a84dcf7f8422bf9a/140.jpg'
  }

  authors() {
    return this.data['_source']['creators'].
      map(e => e.display_name).join(', ')
  }

  involved() {
    return this.data['_source']['involved']
  }

  involvedStr() {
    return this.involved().map(e => e.display_name).join(', ')
  }

  textTypes() {
    return this.data['_source']['text_types'].
      map(e => l(e)).join(', ')
  }

  tags() {
    return this.data['_source']['tags'].
      map(e => l(e)).join(', ')
  }

  project() {
    return l(this.data['_source']['project'])
  }

  citationLink() {
    return 'https://dfk-paris.org/super/link'
  }

  volumes() {
    return this.data['_source']['volumes']
  }

  date() {
    return this.data['_source']['date']
  }

  dateHuman() {
    return this.data['_source']['date_human']
  }

  json() {
    return JSON.stringify(this.data['_source'], null, 2)
  }
}
