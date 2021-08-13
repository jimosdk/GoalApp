require 'spec_helper'
require 'rails_helper'

feature 'the signup process' do
  scenario 'has a new user page' do 
    visit new_user_url
    expect(page).to have_content('New User')
  end

  feature 'signing up a user' do

    scenario 'shows username on the homepage after signup' do
        visit new_user_url
        fill_in 'Name',with: 'tester'
        fill_in 'Password',with: 'biscuits'
        click_on 'Create'
        expect(page).to have_content('tester')
    end
  end

  feature 'with an invalid user' do
    scenario 're-renders the signup page after failed signup' do
      visit new_user_url
      fill_in 'Name',with:'tester'
      click_on 'Create'

      expect(page).to have_content "Password is too short (minimum is 6 characters)"
      expect(page).to have_content('New User')
    end
  end
end

feature 'logging in' do
    subject(:user) {User.create(name:'tester',password:'biscuits')}
    before(:each) {user.reload}
  scenario 'shows username on the homepage after login' do
    visit new_session_url
    fill_in 'Name',with: 'tester'
    fill_in 'Password',with: 'biscuits'
    click_on 'Log in'
    expect(page).to have_content('tester')
  end
end

feature 'with an invalid user' do
    scenario 're-renders the sign in page after a failed sign in' do 
      visit new_session_url
      fill_in 'Name',with:'tester'
      click_on 'Log in'
      expect(page).to have_content "Invalid credentials"
      expect(page).to have_content('Sign in')
    end
end

feature 'logging out' do
    subject(:user) {User.create(name:'tester',password:'biscuits')}
    before(:each) do
        user.reload
        visit new_session_url 
        fill_in 'Name',with: 'tester'
        fill_in 'Password',with: 'biscuits'
        click_on 'Log in'

        visit user_url(User.find_by(name: 'tester'))
        click_on 'Log out'
    end
  scenario 'begins with a logged out state' do 
    expect(page).to have_content('Sign in')
  end

  scenario 'doesn\'t show username on the homepage after logout' do
    expect(page).to_not have_content('tester')
  end

end