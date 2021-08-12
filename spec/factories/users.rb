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
FactoryBot.define do
  factory :user do
    name { "MyString" }
    password_digest { "MyString" }
    session_token { "MyString" }
  end
end
