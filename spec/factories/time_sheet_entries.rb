# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :time_sheet_entry do
    starts_at "2013-01-08 07:02:57"
    ends_at "2013-01-08 07:02:57"
    starts_at "2013-01-08 07:02:57"
    user_id 1
    summary "MyText"
    content "MyText"
  end
end
