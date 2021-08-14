require 'rails_helper'

RSpec.describe GoalsController, type: :controller do

  describe "GET #new" do
    subject(:user) {User.create(name:'John',password:'123456')}
    before(:each) do
      user.reload
    end

    context "when the user is signed in" do
      it "render the new template" do
        allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(user)
        get :new
        expect(response).to render_template("new")
      end
    end

    context "when the user is not signed in" do
      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to(new_session_url)
      end
    end

  end

  describe "POST #create" do
    let(:user) {User.create(name:'John',password:'123456')}
    before(:each) {user.reload}
    context "when goal is valid" do
      it "redirects to the created goal's show page" do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
        post :create,params:{goal:{title:"MyGoal",description:"bla"}}
        expect(response).to redirect_to goal_url(Goal.find_by(title:'MyGoal'))
      end
    end

    context "when goal is not valid" do
      it "re-renders the new template" do 
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
        post :create,params:{goal:{title:"",description:"bla"}}
        expect(response).to render_template(:new)
        expect(flash[:errors]).to_not be_nil
      end
    end

    context "when the user is not signed in" do
      it "redirects to sign in page" do
        post :create,params:{goal:{title:"MyGoal",description:"bla"}}
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "GET #edit" do
    subject(:user) {User.create(name:'John',password:'123456')}
    let(:goal) {Goal.create(title:'MyGoal',description:'bla',user_id:user.id)}
    before(:each) do
      user.reload
      goal.reload
    end

    context "when the user is signed in" do
      it "render the edit template" do
        allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(user)
        get :edit,params: {id:goal.id}
        expect(response).to render_template("edit")
      end
    end

    context "when the user is not signed in" do
      it "redirects to sign in page" do
        get :edit,params:{id: goal.id}
        expect(response).to redirect_to(new_session_url)
      end
    end

  end

  describe "PATCH #update" do
    let(:user) {User.create(name:'John',password:'123456')}
    let(:goal) {Goal.create(title:'MyGoal',description:'bla',user_id:user.id)}
    before(:each) do
      user.reload
      goal.reload
    end
    context "when goal is valid" do
      it "redirects to the created goal's show page" do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
        patch :update,params:{id: Goal.find_by(title:'MyGoal').id,goal:{title:"MyGoal",description:"ba"}}
        expect(response).to redirect_to goal_url(Goal.find_by(title:'MyGoal'))
      end
    end

    context "when goal is not valid" do
      it "re-renders the new template" do 
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
        patch :update,params:{id: Goal.find_by(title:'MyGoal').id,goal:{title:"",description:"ba"}}
        expect(response).to render_template(:edit)
        expect(flash[:errors]).to_not be_nil
      end
    end

    context "when the user is not signed in" do
      it "redirects to sign in page" do
        patch :update,params:{id: Goal.find_by(title:'MyGoal').id,goal:{title:"MyGoal",description:"ba"}}
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "GET #show" do
    let(:user) {User.create(name:'John',password:'123456')}
    let(:user2) {User.create(name:'Jim',password:'123456')}
    let(:goal) {Goal.create(title:'MyGoal',description:'bla',user_id:user.id)}
    let(:goal2) {Goal.create(title:'MyGoal',description:'bla',user_id:user2.id,private: true)}
    before(:each) do
      user.reload
      user2.reload
      goal.reload
      goal2.reload
    end
    it "renders the show template" do
      allow_any_instance_of(ApplicationController).
      to receive(:current_user).and_return(user)
      get :show, params:{id: Goal.find_by(user_id: user.id).id}
      expect(response).to render_template(:show)
    end

    context "If an unsigned user is trying to access a private goal of another user" do 
      it "redirects to the other users show page" do
        allow_any_instance_of(ApplicationController).
      to receive(:current_user).and_return(user)
        get :show, params:{id: Goal.find_by(user_id: user2.id).id}
        expect(response).to redirect_to(user_url(user2.id))
      end
    end

    context "If a signed user is trying to access a private goal of another user" do 
      it "redirects to the other users show page" do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
        get :show, params:{id: Goal.find_by(user_id: user2.id).id}
        expect(response).to redirect_to(user_url(user2.id))
      end
    end

    context "If a signed user is trying to access his own private goal" do 
      it "renders the goals show page" do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user2)
        get :show, params:{id: Goal.find_by(user_id: user2.id).id}
        expect(response).to render_template(:show)
      end
    end
  end

  describe "PATCH #complete" do
    let(:user) {User.create(name:'John',password:'123456')}
    let(:user2) {User.create(name:'Jim',password:'123456')}
    let(:goal) {Goal.create(title:'MyGoal',description:'bla',user_id:user.id)}
    before(:each) do 
      user.reload
      user2.reload
      goal.reload
    end
    context "when request is sent by the author of a goal" do
      before(:each) do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
        patch :complete,params:{id: goal.id}
      end
      it "toggles the goal's complete attribute" do 
        goal.reload
        expect(goal.completed).to be true
      end

      it "redirects to the goal's show page" do 
        expect(response).to redirect_to(goal_url(goal))
      end
    end

    context "when request is not sent by the author of a goal" do
      before(:each) do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user2)
        patch :complete,params:{id: goal.id}
      end
      it "doesn't toggle the goal's complete attribute" do
        goal.reload
        expect(goal.completed).to be false
      end
      it "redirects to the goal show page" do
        expect(response).to redirect_to(goal_url(goal))
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) {User.create(name:'John',password:'123456')}
    let(:user2) {User.create(name:'Jim',password:'123456')}
    let(:goal) {Goal.create(title:'MyGoal',description:'bla',user_id:user.id)}
    before(:each) do 
      user.reload
      user2.reload
      goal.reload
    end
    context "when request is sent by the author of a goal" do
      before(:each) do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
        delete :destroy,params:{id: goal.id}
      end
      it "deletes the goal" do 
        expect(user.goals).to_not include(goal)
      end

      it "redirects to the author's show page" do 
        expect(response).to redirect_to(user_url(user))
      end
    end

    context "when request is not sent by the author of a goal" do
      before(:each) do
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user2)
        delete :destroy,params:{id: goal.id}
      end
      it "doesn't delete the goal" do
        user.reload
        expect(user.goals).to include(goal)
      end
      it "redirects to the goal's show page" do
        expect(response).to redirect_to(goal_url(goal))
      end
    end
  end

end
