class TimeSheetEntry < ActiveRecord::Base
  attr_accessible :content, :ends_at, :starts_at, :starts_at, :summary, :user_id

  belongs_to :time_sheet_entry
  belongs_to :topic
end
