import {Url} from '@wendig/lib'
import search from './search'

class UrlSearch {
  constructor(component) {
    this.cmp = component
  }

  setup() {
    this.cmp.state = this.cmp.state || {}
    this.cmp.state['criteria'] = {}

    this.cmp.onDelayedInput = (values) => this.onDelayedInput(values)
    this.cmp.onInput = (values) => this.onInput(values)
    this.onUrlChanged = this.onUrlChanged.bind(this)

    window.addEventListener('hashchange', this.onUrlChanged)
    this.onUrlChanged()
  }

  teardown() {
    window.removeEventListener('hasnchange', this.onUrlChanged)
  }

  onInput(values) {
    this.updateCriteriaState(values)
    this.cmp.update()

    const url = Url.current()
    url.updateHashParams(values)
    url.apply()
  }

  onUrlChanged(event) {
    const p = params()

    this.updateCriteriaState(p)
    if (event) {this.cmp.update()}

    this.cmp.onSearch(p)
  }

  onDelayedInput(values) {
    if (this.timeout) {
      window.clearTimeout(this.timeout)
      this.timeout = null
    }

    const handler = () => this.onInput(values)
    this.timeout = window.setTimeout(handler, 300)
  }

  updateCriteriaState(values) {
    for (const [k, v] of Object.entries(values)) {
      if (v == null) {
        delete this.cmp.state.criteria[k]
      } else {
        this.cmp.state.criteria[k] = v
      }
    }
  }
}

const params = () => {
  const defaults = {
    decode: true,
    parseIntList: ['page', 'per_page']
  }

  const url = Url.current()
  const result = {
    page: 1,
    perPage: 10,
    ...url.hashParams(defaults)
  }

  return result
}

// class UrlSearch {
//   constructor(opts = {}) {
//     this.opts = {...defaults, ...opts}


//   }

//   controlsChanged(newParams) {

//   }

//   urlChanged() {
//     search.search(this.params())
//   }

//   updateParams(newParams) {
//     const url = Url.current()
//     url.updateHashParams(newParams)
//     url.apply()
//   }
// }

export {
  UrlSearch,
  params
}
