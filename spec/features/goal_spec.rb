require 'rails_helper'
require 'spec_helper'

feature "goal creation process" do
    let(:user){User.create!(name:'John',password:'123456')}
    before(:each) do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
        user.reload
    end
    scenario 'has a new goal page' do
        visit new_goal_url
        expect(page).to have_content('New Goal')
    end

    feature "creating a goal" do
        scenario "shows new goal's title on the authors page after creating new goal" do
            visit new_goal_url
            fill_in 'Title',with: 'testgoal'
            fill_in 'Description',with: 'biscuits'
            click_on 'Create'
            expect(page).to have_content('testgoal')
            visit user_url(user)
            expect(page).to have_content('testgoal')
        end
    end
end

feature "private goals" do
    let(:user){User.create!(name:'John',password:'123456')}
    let(:user2){User.create!(name:'Jim',password:'123456')}
    let(:goal) {Goal.create!(title:'MyGoal',private: true ,user_id:user.id)}
    before(:each) do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user2)
        user.reload
        user2.reload
        goal.reload
    end

    scenario "other users can't see a private goal in the list of goals on the authors's show page" do
        visit user_url(goal.user_id)
        expect(page).to_not have_content 'MyGoal'
    end
    scenario "other users can't see the show page of private goals" do
        visit goal_url(goal)
        expect(page).to have_content 'John\'s Profile'
    end

    scenario "user's can see their own private goals" do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
        visit goal_url(goal)
        expect(page).to have_content 'MyGoal'
        expect(page).to have_content 'Visibility'
        expect(page).to have_content 'Private'
    end
end
feature "marking a goal complete" do
    let(:user){User.create!(name:'John',password:'123456')}
    let(:user2){User.create!(name:'Jim',password:'123456')}
    let(:goal) {Goal.create!(title:'MyGoal',private: true ,user_id:user.id)}
    before(:each) do
        user.reload
        user2.reload
        goal.reload
    end

    scenario "a user can toggle his goals completed attribute" do 
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user) 
        visit goal_url(goal)
        click_on 'Complete'
        expect(page).to_not have_content 'Ongoing'
        expect(page).to have_content 'Completed'
        expect(page).to have_button 'Not completed yet'
    end

    scenario "users can't toggle the completed attribute of another user's goal" do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user2)
        visit goal_url(goal)
        expect(page).to_not have_button 'Complete'
        expect(page).to_not have_content 'Completed?'
    end
end
feature "editing a goal" do 
    let(:user){User.create!(name:'John',password:'123456')}
    let(:user2){User.create!(name:'Jim',password:'123456')}
    let(:goal) {Goal.create!(title:'testgoal',description:'biscuits',user_id:user.id)}
    before(:each) do
        user.reload
        user2.reload
        goal.reload
    end
    scenario 'has a edit goal page' do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
        visit edit_goal_url(goal)
        expect(page).to have_content("Edit #{goal.user.name}'s Goal")
    end

    scenario "users can't edit other users goals" do 
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user2)
        visit edit_goal_url(goal)
        expect(page).to_not have_content("Edit #{goal.user.name}'s Goal")
        expect(page).to have_content("#{goal.title}")
        expect(page).to have_content('Author')
        expect(page).to have_content('Description')
    end

    feature "editing a goal" do
        scenario "reflects changes on the goals show page" do
            allow_any_instance_of(ApplicationController).
            to receive(:current_user).and_return(user)
            visit edit_goal_url(goal)
            fill_in 'Title',with: 'test2goal'
            fill_in 'Description',with: 'biscuits3'
            click_on 'Change'
            expect(page).to have_content('test2goal')
            expect(page).to have_content('biscuits3')
        end
    end
end
feature "deleting a goal" do
    let(:user){User.create!(name:'John',password:'123456')}
    let(:user2){User.create!(name:'Jim',password:'123456')}
    let(:goal) {Goal.create!(title:'MyGoal' ,user_id:user.id)}
    before(:each) do
        user.reload
        user2.reload
        goal.reload
    end

    scenario "a user can delete his own goals" do 
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user) 
        visit goal_url(goal)
        click_on 'Remove'
        expect(page).to_not have_content "#{goal.title}"
        expect(page).to have_content "#{user.name}'s Profile"
        
    end

    scenario "users can't delete another user's goal" do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user2)
        visit goal_url(goal)
        expect(page).to_not have_button 'Remove'
    end
end

