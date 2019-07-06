class Dfkv::Klass < ActiveRecord::Base
  has_many :kinds, class_name: '::Dfkv::Kind'
  has_many :attribs, through: :kinds, class_name: '::Dfkv::Attrib'
end