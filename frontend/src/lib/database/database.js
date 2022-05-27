export default class Database {
  constructor() {
    this.queue = []
    this.ready = false

    this.actions = {}

    this.handler = this.handler.bind(this)
    this.loaded = this.loaded.bind(this)
  }

  action(name, implementation) {
    this.actions[name] = implementation
  }

  handler(event) {
    if (!this.ready) {
      this.queue.push(event)
      return
    }

    const messageId = event.data.messageId
    const now = new Date()

    for (const [name, implementation] of Object.entries(this.actions)) {
      if (name == event.data.action) {
        const results = implementation(event.data)

        postMessage({
          messageId: messageId,
          action: `${name}-results`,
          ...results
        })

        console.log(`'${name}' request handled in ${new Date() - now} ms`)
        break
      }
    }

    postMessage({action: 'unknown-action', payload: event.data})

  }

  loaded() {
    console.log(`database loaded`)

    this.ready = true
    for (const job of this.queue) {
      this.handler(job)
    }
    this.queue = []
  }
}
