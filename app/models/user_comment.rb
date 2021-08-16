# == Schema Information
#
# Table name: user_comments
#
#  id           :bigint           not null, primary key
#  body         :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  commented_id :integer          not null
#  commenter_id :integer          not null
#
# Indexes
#
#  index_user_comments_on_commented_id  (commented_id)
#  index_user_comments_on_commenter_id  (commenter_id)
#
class UserComment < ApplicationRecord
    validates :body,presence: true

    belongs_to :commenter,
        class_name: :User 

    belongs_to :commented,
        class_name: :User 
end
