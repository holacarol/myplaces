require 'spec_helper'

describe FriendshipsController do

  describe "access control" do
  
    it "should require signin for create" do
      post :create
      response.should redirect_to(new_user_session_path)
    end

    it "should require signin for update" do
      put :update, :id => 1
      response.should redirect_to(new_user_session_path)
    end

    it "should require signin for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = Factory(:user)
      sign_in(@user)
      @friend = Factory(:user, :email => Factory.next(:email))
    end

    it "should create a friendship request" do
      lambda do
        post :create, :friendship => { :friend_id => @friend }
        response.should be_redirect
      end.should change(Friendship, :count).by(2)
    end

    it "should create a friendship request using Ajax" do
      lambda do
        xhr :post, :create, :friendship => { :friend_id => @friend }
        response.should be_success
      end.should change(Friendship, :count).by(2)
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      sign_in(@user)
      @friend = Factory(:user, :email => Factory.next(:email))
      Friendship.request(@user, @friend)
      @friendship = @friend.friendships.find_by_friend_id(@user)
    end

    it "should accept a relationship" do
      lambda do
        put :update, :id => @friendship
        response.should be_redirect
      end.should change(Friendship, :count).by(0)
    end

    it "should accept a relationship" do
      lambda do
        xhr :put, :update, :id => @friendship
        response.should be_success
      end.should change(Friendship, :count).by(0)
    end
  end


  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
      sign_in(@user)
      @friend = Factory(:user, :email => Factory.next(:email))
      Friendship.request(@user, @friend)
      Friendship.accept(@user, @friend)
      @friendship = @user.friendships.find_by_friend_id(@friend)
    end

    it "should destroy a friendship one way" do
      lambda do
        delete :destroy, :id => @friendship
        response.should be_redirect
      end.should change(Friendship, :count).by(-2)
    end

    it "should destroy a friendship using Ajax" do
      lambda do
        xhr :delete, :destroy, :id => @friendship
        response.should be_success
      end.should change(Friendship, :count).by(-2)
    end
  end
end

