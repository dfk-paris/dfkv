require 'json'
require 'yaml'


bundles = [:default]
bundles << :development if ENV['RACK_ENV'] != 'production'

p bundles

require 'bundler'
Bundler.setup(bundles)

require 'active_record'

module Dfkv
  CONFIG = YAML.load_file('app.yml')
end

ActiveRecord::Base.establish_connection(Dfkv::CONFIG['db']['final'])

require 'dfkv/attrib'
require 'dfkv/attribution'
require 'dfkv/contribution'
require 'dfkv/kind'
require 'dfkv/klass'
require 'dfkv/person'
require 'dfkv/record'
require 'dfkv/server'
