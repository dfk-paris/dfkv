class Dfkv::Attrib < ActiveRecord::Base
  belongs_to :kind, class_name: '::Dfkv::Kind'
end