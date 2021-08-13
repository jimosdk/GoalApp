require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #new" do
    it "renders the new template" do
      get :new,{}
      expect(response).to render_template("new")
    end

    context "when user is already signed in " do
      subject(:user) {User.create(name: 'John',password:'123456')}
      before(:each) do 
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
        user.reload
      end
      it "redirects to user show page" do 
        get :new,{}
        expect(response).to redirect_to(user_url(User.find_by(name:'John')))
      end
    end
  end

  describe "POST #create" do
    context "when user is valid" do
      # before(:all) do 
      #   post :create, params: {user: { name: 'John',password:'123456'}}
      # end
      it "logs in the user" do 
        post :create, params: {user: { name: 'John',password:'123456'}}
        expect(session[:session_token]).to_not be_nil
      end
      it "redirects to user show page" do
        post :create, params: {user: { name: 'John',password:'123456'}}
        expect(response).to redirect_to(user_url(User.find_by(name:'John').id))
      end
      
    end
    
    context "when user is not valid" do
      it "passes an error message" do
        post :create, params:{user:{name:'',password:''}}
        expect(flash[:errors]).to_not be_nil
      end
      it "renders the new template" do
        post :create, params:{user:{name:'',password:''}}
        expect(response).to render_template("new")
      end
    end

    context "when user is already signed in " do
      subject(:user) {User.create(name: 'John',password:'123456')}
      before(:each) do 
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
        user.reload
      end
      it "redirects to user show page" do 
        post :create,params:{user: { name: 'John',password:'123456'}}
        expect(response).to redirect_to(user_url(User.find_by(name:'John')))
      end
    end
  end

  describe "GET #show" do
    subject(:user) {User.create(name: 'John',password:'123456')}
    before (:each) {user.reload}
    context "when the user is not signed in " do
      it "redirects to Sign in page" do 
        get :show ,params:{id: User.find_by(name:'John').id}
        expect(response).to redirect_to(new_session_url)
      end
    end

    context "when the user is signed in " do
      before(:each) do 
        allow_any_instance_of(ApplicationController).
        to receive(:current_user).and_return(user)
      end
      it "renders the users show page" do
        get :show ,params:{id: User.find_by(name:'John').id}
        expect(response).to render_template(:show)
      end
    end
  end

end
