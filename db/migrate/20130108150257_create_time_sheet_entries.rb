class CreateTimeSheetEntries < ActiveRecord::Migration
  def change
    create_table :time_sheet_entries do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.datetime :starts_at
      t.integer :user_id
      t.text :summary
      t.text :content

      t.timestamps
    end
  end
end
