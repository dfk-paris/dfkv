class Dfkv::Kind < ActiveRecord::Base
  belongs_to :klass, class_name: '::Dfkv::Klass'
  has_many :attribs, class_name: '::Dfkv::Kind'
end