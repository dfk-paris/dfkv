import {bus} from './bus'

class Watchlist {
  static VERSION = 1

  count() {
    return this.unpack().length
  }

  clear() {
    this.pack([])
    bus.emit('watchlist-changed')
  }

  has(id) {
    const tmp = this.unpack()
    const found = tmp.find(e => e.id == id)

    return !!found
  }

  toggle(id, criteria = null) {
    const tmp = this.unpack()
    const found = tmp.find(e => e.id == id)

    if (!found) {
      tmp.push({id, criteria})
    } else {
      const index = tmp.indexOf(found)
      tmp.splice(index, 1)
    }

    this.pack(tmp)

    bus.emit('watchlist-changed')
  }

  unpack() {
    return JSON.parse(window.localStorage.watchlist || '[]')
  }

  pack(data) {
    window.localStorage.watchlist = JSON.stringify(data)
  }
}

const watchlist = new Watchlist()

// to empty the watchlist when the data structure has changed, change the
// version, see above
if (window.localStorage.watchlistVersion != Watchlist.VERSION) {
  watchlist.clear()
  window.localStorage.watchlistVersion = Watchlist.VERSION
}

export default watchlist
