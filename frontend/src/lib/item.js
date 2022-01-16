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

  volumes() {
    return this.data['_source']['volumes']
  }

  date() {
    return this.data['_source']['date']
  }

  dateHuman() {
    return this.data['_source']['date_human']
  }
}
