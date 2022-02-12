class AppEvent extends Event {
  constructor(typeArg, data = null) {
    super(typeArg)
    this.data = data
  }
}

class Bus extends EventTarget {
  constructor() {
    super()

    this.data = {}
  }

  emit(name, data) {
    const event = new AppEvent(name, data)
    this.dispatchEvent(event)
  }
}

const bus = new Bus()

function BusRiotPlugin(component) {
  const {onBeforeMount, onBeforeUnmount} = component

  component.onBeforeMount = (props, state) => {
    component.bus = bus
    component.handlers = []

    onBeforeMount.apply(component, [props, state])
  }

  component.on = (event, handler) => {
    component.handlers.push([event, handler])
    bus.addEventListener(event, handler)
  }

  component.onBeforeUnmount = (props, state) => {
    for (const [e, h] of component.handlers) {
      bus.removeEventListener(e, h)
    }

    onBeforeUnmount.apply(component, [props, state])
  }
}

export {
  AppEvent,
  bus,
  BusRiotPlugin
}