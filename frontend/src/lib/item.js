import {i18n, util} from '@wendig/lib'

const l = i18n.localize

export default class Item {
  constructor(data) {
    this.data = data
  }

  setCriteria(c) {
    this.data.criteria = c
  }

  criteria() {
    // console.log(this.data.criteria)
    return this.data.criteria
  }

  id() {
    return this.data['_source']['id']
  }

  url() {
    return `${staticUrl}/#/records/${this.id()}`
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

  creators() {
    const data = this.data['_source']['creators']
    return util.sortBy(data, e => e.display_name[0])
  }

  authors() {
    return this.creators().
      map(e => e.display_name[0]).
      join('; ')
  }

  involved() {
    const data = this.data['_source']['involved']
    return util.sortBy(data, e => e.display_name[0])
  }

  involvedStr() {
    return this.involved().map(e => e.display_name[0]).join(', ')
  }

  textTypes() {
    return this.data['_source']['text_types'].
      map(e => l(e)).join(', ')
  }

  tags() {
    return this.data['_source']['tags'].
      map(e => l(e)).join('; ')
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

  contributionType() {
    return this.data['_source']['contribution_type']
  }
}
