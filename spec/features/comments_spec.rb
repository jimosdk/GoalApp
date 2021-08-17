require 'rails_helper'

feature "comments on user profiles" do
    let(:user) {User.create(name:'John',password:'123456')}
    let(:user2) {User.create(name:'Jimos',password:'123456')}
    feature "creating new comment" do
        scenario "comment is rendered on the commented user's show page" do
            allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user2)
            visit user_url(user)
            fill_in 'New comment' ,with: 'Comment body'
            click_on 'Comment'

            expect(page).to have_content 'Comment body'
        end
    end

    feature "deleting a comment" do
        let(:comment) {UserComment.create(body:"Comment body",commenter_id: user2.id,commented_id: user.id)}
        before(:each) {comment.reload}
        context "when user is the author of the comment" do
            scenario "comment is removed from the commented user's show page" do
                allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user2)
                visit user_url(user)
                click_on 'Delete Comment'

                expect(page).to_not have_content 'Comment body'
            end
        end

        context "when user is not the author of the comment" do
            scenario "there is no delete button displayed on the page" do
                allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
                visit user_url(user)

                expect(page).to have_content 'Comment body'
                expect(page).to_not have_button 'Delete Comment'
            end
        end
    end

    context "when a commenter's profile is deleted" do
        let(:comment) {UserComment.create(body:"Comment body",commenter_id: user2.id,commented_id: user.id)}
        before(:each) do
            user2.reload
            comment.reload
        end
        scenario "his comments remain" do
            user2.destroy
            visit user_url(user)

            expect(page).to have_content 'Comment body'
            expect(page).to have_content 'Deleted User'
            expect(page).to_not have_link 'Jimos'
        end
    end
end

feature "comments on user's goals" do
    let(:user) {User.create(name:'John',password:'123456')}
    let(:user2) {User.create(name:'Jimos',password:'123456')}
    let(:goal) {Goal.create(title:'MyGoal',user_id:user.id)}
    before(:each) do 
        user.reload
        user2.reload
        goal.reload
    end

    feature "creating new comment" do
        scenario "comment is rendered on the commented goal's show page" do
            allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user2)
            visit goal_url(goal)
            fill_in 'New comment' ,with: 'Comment body'
            click_on 'Comment'

            expect(page).to have_content 'Comment body'
        end
    end

    feature "deleting a comment" do
        let(:comment) {GoalComment.create!(body:"Comment body",commenter_id: user2.id,goal_id: goal.id)}
        before(:each) {comment.reload}
        context "when user is the author of the comment" do
            scenario "comment is removed from the commented goal's show page" do
                allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user2)
                visit goal_url(goal)
                click_on 'Delete Comment'

                expect(page).to_not have_content 'Comment body'
            end
        end

        context "when user is not the author of the comment" do
            scenario "there is no delete button displayed on the page" do
                allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
                visit goal_url(goal)

                expect(page).to have_content 'Comment body'
                expect(page).to_not have_button 'Delete Comment'
            end
        end
    end

    context "when a commenter's profile is deleted" do
        let(:comment) {GoalComment.create(body:"Comment body",commenter_id: user2.id,goal_id: goal.id)}
        before(:each) do
            user2.reload
            comment.reload
        end
        scenario "his comments remain" do
            allow_any_instance_of(ApplicationController).
            to receive(:current_user).and_return(user)
            user2.destroy
            visit goal_url(goal)

            expect(page).to have_content 'Comment body'
            expect(page).to have_content 'Deleted User'
            expect(page).to_not have_link 'Jimos'
        end
    end
end