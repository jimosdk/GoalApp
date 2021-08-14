# == Schema Information
#
# Table name: goals
#
#  id          :bigint           not null, primary key
#  completed   :boolean          default(FALSE), not null
#  description :text
#  private     :boolean          default(FALSE), not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_goals_on_user_id  (user_id)
#
FactoryBot.define do
  factory :goal do
    title { "MyString" }
    description { "MyText" }
    user_id { 1 }
    private { false }
    completed { "" }
  end
end
