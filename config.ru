require 'bundler'
Bundler.setup

require 'rack'
require 'rack/cors'
require 'rack/static'

$: << __dir__ + '/lib'
require 'dfkv'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :options]
  end
end

# run Rack::Cascade.new([
#   Rack::Static.new(Dfkv::Server, urls: [''], root: 'public', cascade: true),
#   Dfkv::Server
# ])

# use Rack::Static, urls: [''], root: 'public', cascade: true
 
run Dfkv::Server
