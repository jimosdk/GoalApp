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
require 'rails_helper'

RSpec.describe Goal, type: :model do
  it {should validate_presence_of(:title)}
  
  it {should belong_to(:user)}
end
