# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_session_token  (session_token) UNIQUE
#
class User < ApplicationRecord

    attr_reader :password

    validates :name,:password_digest,:session_token,presence:true
    validates :session_token,uniqueness:true
    validates :password,length: {minimum: 6,allow_nil:true}

    after_initialize :ensure_session_token

    has_many :goals

    has_many :user_comments,                     #comments on users
        foreign_key: :commenter_id
    
    has_many :commented_users,                  #list of users that this user has commented
        ->{distinct},                 
        through: :user_comments,
        source: :commented

    has_many :comments,                          #comments by other users
        foreign_key: :commented_id,
        class_name: :UserComment,
        dependent: :destroy

    has_many :commenters,                          #users that have posted a comment on this user
        ->{distinct},
        through: :comments,
        source: :commenter

    has_many :goal_comments,                        #list of comments on goals
        foreign_key: :commenter_id

    has_many :commented_goals,                  #list of goals that this user has commented on
        ->{distinct},
        through: :goal_comments,
        source: :goal

    def self.find_by_credentials(name,password)
        user = User.find_by(name: name)
        user && user.is_password?(password) ? user : nil
    end

    def password=(password)
        @password = password 
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def reset_session_token!
        self.session_token = User.generate_session_token 
        self.save!
        self.session_token
    end

    private 

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def ensure_session_token
        self.session_token ||= User.generate_session_token
    end
end
