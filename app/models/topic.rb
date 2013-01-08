class Topic < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :time_sheet_entries
end
