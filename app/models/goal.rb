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
class Goal < ApplicationRecord
    validates :title,presence: true

    belongs_to :user,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :User

    has_many :comments,
        class_name: :GoalComment,
        dependent: :destroy

    has_many :commenters,
        ->{distinct},
        through: :comments,
        source: :commenter
end
