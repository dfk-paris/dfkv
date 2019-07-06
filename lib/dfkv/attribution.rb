class Dfkv::Attribution < ActiveRecord::Base
  self.table_name = 'attribs_records'

  belongs_to :record
  belongs_to :attrib
end