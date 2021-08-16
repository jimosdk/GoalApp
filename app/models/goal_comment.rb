# == Schema Information
#
# Table name: goal_comments
#
#  id           :bigint           not null, primary key
#  body         :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  commenter_id :integer          not null
#  goal_id      :integer          not null
#
# Indexes
#
#  index_goal_comments_on_commenter_id  (commenter_id)
#  index_goal_comments_on_goal_id       (goal_id)
#
class GoalComment < ApplicationRecord
    validates :body,presence: true 

    belongs_to :commenter,
        class_name: :User  

    belongs_to :goal 
end
