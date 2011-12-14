require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(new_user_session_path)
        flash[:alert].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do

      before(:each) do
        @user = Factory(:user)
        sign_in @user
        second = Factory(:user, :name => "Bob", :email => "another@example.com")
        third  = Factory(:user, :name => "Ben", :email => "another@example.net")
        
        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :content => "2")
        response.should have_selector("a", :content => "Next")
      end
    end
  end

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end

    it "should show the user's cards" do
      @place1 = Factory(:place, :googleid => "id1", :googleref => "ref1", :name => "Name1")
      @place2 = Factory(:place, :googleid => "id2", :googleref => "ref2", :name => "Name2")
      card1 = Factory(:card, :user => @user, :place => @place1, :comment => "Foo bar")
      card2 = Factory(:card, :user => @user, :place => @place2, :comment => "Baz quux")
      get :show, :id => @user
      response.should have_selector("span.comment", :content => card1.comment)
      response.should have_selector("span.comment", :content => card2.comment)
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        sign_in(admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end

  describe "friendship pages" do

    describe "when not signed in" do

      it "should protect 'friends'" do
        get :friends, :id => 1
        response.should redirect_to(new_user_session_path)
      end

      it "should protect 'pending_friends'" do
        get :pending_friends, :id => 1
        response.should redirect_to(new_user_session_path)
      end

      it "should protect 'requested_friends'" do
        get :requested_friends, :id => 1
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "when signed in" do

      before(:each) do
        @user = Factory(:user)
        sign_in(@user)
        @other_user = Factory(:user, :email => Factory.next(:email))
        Friendship.request(@user, @other_user)
      end

      it "should show user pending" do
        get :pending_friends, :id => @user
        response.should have_selector("a", :href => user_path(@other_user),
                                           :content => @other_user.name)
      end

      it "should show user requested" do
        get :requested_friends, :id => @other_user
        response.should have_selector("a", :href => user_path(@user),
                                           :content => @user.name)
      end

      it "should show user friend" do
        Friendship.accept(@user, @other_user)
        get :friends, :id => @user
        response.should have_selector("a", :href => user_path(@other_user),
                                           :content => @other_user.name)
      end

      it "should show user friend" do
        Friendship.accept(@user, @other_user)
        get :friends, :id => @other_user
        response.should have_selector("a", :href => user_path(@user),
                                           :content => @user.name)
      end
    end
  end
end

