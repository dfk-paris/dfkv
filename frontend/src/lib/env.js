const env = {}

for (const e of document.querySelectorAll("meta[name^='env-']")) {
  env[e.getAttribute('name')] = e.getAttribute('content')
}

export default env
