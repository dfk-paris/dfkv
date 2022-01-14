# require 'json'
# require 'yaml'


RACK_ENV = ENV['RACK_ENV'] || 'development'

$: << File.expand_path(__dir__)

bundles = [:default]
bundles << :development if RACK_ENV != 'production'

require 'bundler'
Bundler.setup(bundles)
Bundler.require(*bundles)

require 'dotenv/load'

module Dfkv
  autoload :Elastic, 'dfkv/elastic'
  autoload :Server, 'dfkv/server'
  autoload :Tasks, 'dfkv/tasks'

  def self.progress_bar(title, total, options = {})
    options = {
      title: title,
      total: total,
      format: "%t: |%B|%R/s|%c/%C (%P%%)|%a%E|",
      throttle_rate: 0.5
    }.merge(options)

    ProgressBar.create(options)
  end
end
