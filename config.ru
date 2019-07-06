require 'bundler'
Bundler.setup

require 'rack'
require 'rack/cors'

$: << __dir__ + '/lib'
require 'dfkv'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :options]
  end
end

run Dfkv::Server
