import * as riot from 'riot'

const PARENT_KEY = riot.__.globals['PARENT_KEY_SYMBOL']

export default function(component) {
  const {onBeforeMount, onBeforeUnmount} = component

  component.onBeforeMount = (props, state) => {
    const parent = component[PARENT_KEY]

    if (parent) {
      parent.tags = parent.tags || {}
      parent.tags[component.name] = parent.tags[component.name] || []
      parent.tags[component.name].push(component)
    }

    onBeforeMount.apply(component, [props, state])
  }

  component.onBeforeUnmount = (props, state) => {
    const parent = component[PARENT_KEY]

    if (parent) {
      const arr = parent.tags[component.name]
      const index = arr.indexOf(component)
      arr.splice(index, 1)
      if (!arr.length) {
        delete parent.tags[component.name]
      }
    }

    onBeforeUnmount.apply(component, [props, state])
  }

  return component
}
