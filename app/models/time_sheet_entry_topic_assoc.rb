class TimeSheetEntryTopicAssoc < ActiveRecord::Base
  attr_accessible :time_sheet_entry_id, :topic_id

  has_many :topics
end
