import {Url} from '@wendig/lib'
import search from './search'

const params = () => {
  const defaults = {
    decode: true,
    parseInt: ['page', 'per_page']
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
  params
}
