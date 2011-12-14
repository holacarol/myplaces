require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do

    describe "when not signed in" do
    
      before(:each) do
        get :home
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title",
                        :content => "#{@base_title} | Home")
      end
    end

    describe "when signed in" do

      before(:each) do
        @user = Factory(:user)
        sign_in(@user)
        other_user = Factory(:user, :email => Factory.next(:email))
        Friendship.request(@user, other_user)
      end

      it "should have the right friends counts" do
        get :home
        response.should have_selector("a", :href => friends_user_path(@user),
                                           :content => "0 friends")
        response.should have_selector("a", :href => pending_friends_user_path(@user),
                                           :content => "1 pending friend")
        response.should have_selector("a", :href => requested_friends_user_path(@user),
                                           :content => "0 requested friends")
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                        :content =>
                          "Ruby on Rails Tutorial Sample App | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                        :content =>
                          "Ruby on Rails Tutorial Sample App | About")
    end
  end
end

