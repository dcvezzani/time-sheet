class CreateTimeSheetEntryTopicAssocs < ActiveRecord::Migration
  def change
    create_table :time_sheet_entry_topic_assocs do |t|
      t.integer :time_sheet_entry_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
