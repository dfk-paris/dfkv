export default class Item {
  constructor(data) {
    this.data = data
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
}
