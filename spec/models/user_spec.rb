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
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) {User.new(name: 'John',password:'123456')}

  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:password_digest)}
  it {should validate_presence_of(:session_token)}

  it {should validate_length_of(:password).is_at_least(6).allow_nil}

  it {should validate_uniqueness_of(:session_token)}

  describe "#password=" do
    it 'it sets the password' do
      expect(user.instance_variable_get(:@password)).to_not be_nil
    end
    it 'it sets the password_digest' do 
      expect(user.password_digest).to_not be_nil
    end
  end

  describe "#is_password?" do
    it 'returns true if the password matches' do
      expect(user.is_password?('123456')).to be true
    end
    it 'returns false if the password doesn\'t match' do
      expect(user.is_password?('12')).to be false
    end
  end

  describe "#reset_sesison_token!" do
    it "changes the value of session_token" do
      old_token = user.session_token 
      user.reset_session_token!
      expect(user.session_token).to_not eq(old_token)
    end
    it "saves the user" do
      expect(user).to receive(:save!)
      user.reset_session_token!
    end
    it "returns the new session_token" do
      expect(user.reset_session_token!).to eq(user.session_token)
    end
  end

  describe "::find_by_credentials" do
    before(:each) {user.save}
    it "returns nil if the name doesn't match" do
      expect(User.find_by_credentials('Jon','123456')).to be_nil
    end
    it "returns nil if the password doesn't match" do
      expect(User.find_by_credentials('John','1234567')).to be_nil
    end
    it "returns the user if the credentials are valid" do
      user2 = User.find_by_credentials('John','123456')
      expect(user2).to be_an(User)
      expect(user2.name).to eq('John')
      expect(user2.is_password?('123456')).to be true
    end
  end

end
