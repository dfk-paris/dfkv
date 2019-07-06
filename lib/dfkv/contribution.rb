class Dfkv::Contribution < ActiveRecord::Base
  self.table_name = 'people_records'

  belongs_to :record
  belongs_to :person
  belongs_to :role, class_name: '::Dfkv::Attrib'
end