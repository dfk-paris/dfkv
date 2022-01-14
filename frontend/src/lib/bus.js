class AppEvent extends Event {
  constructor(typeArg, data = null) {
    super(typeArg)
    this.data = data
  }
}

class Bus extends EventTarget {
  emit(name, data) {
    const event = new AppEvent(name, data)
    this.dispatchEvent(event)
  }
}

const bus = new Bus()

function BusRiotPlugin(component) {
  const {onBeforeMount} = component

  component.onBeforeMount = (props, state) => {
    component.bus = bus

    onBeforeMount.apply(component, [props, state])
  }

}

export {
  AppEvent,
  bus,
  BusRiotPlugin
}