import {Url} from '@wendig/lib'
import search from './search'



class UrlSearch {
  constructor(opts = {}) {
    this.opts = {...defaults, ...opts}


  }

  controlsChanged(newParams) {

  }

  urlChanged() {
    search.search(this.params())
  }

  params(opts = {}) {
    const defaults = {
      decode: true,
      parseInt: ['page', 'per_page']
    }

    const options = {...defaults, opts}

    const url = Url.current()
    const result = {
      page: 1,
      perPage: 10,
      ...url.hashParams(options)
    }
    return result
  }

  updateParams(newParams) {
    const url = Url.current()
    url.updateHashParams(newParams)
    url.apply()
  }
}

export default UrlSearch
