require 'json'
require 'yaml'

require 'bundler'
Bundler.setup

require 'active_record'
require 'pry'


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
