require 'spec_helper'

describe CardsController do
  render_views
  
  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = Factory(:user)
      sign_in(@user)
    end

    describe "failure" do

      before(:each) do
        @place_attr = {:googleid => "id1", :googleref => "ref1", :name => "name1"}
        @attr = { :comment => "", :place_attributes => @place_attr }
      end

      it "should not create a card" do
        lambda do
          post :create, :card => @attr
        end.should_not change(Card, :count)
      end

      it "should render the home page" do
        post :create, :card => @attr
        response.should render_template('pages/home')
      end
    end

    describe "success" do

      before(:each) do
        @place_attr = {:googleid => "id1", :googleref => "ref1", :name => "name1"}
        @attr = { :comment => "Lorem ipsum", :place_attributes => @place_attr }
      end

      it "should create a card" do
        lambda do
          post :create, :card => @attr
        end.should change(Card, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :card => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :card => @attr
        flash[:success].should =~ /card created/i
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        sign_in(wrong_user)
        @card = Factory(:card, :user => @user)
      end

      it "should deny access" do
        delete :destroy, :id => @card
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = Factory(:user)
        sign_in(@user)
        @card = Factory(:card, :user => @user)
      end

      it "should destroy the card" do
        lambda do 
          delete :destroy, :id => @card
        end.should change(Card, :count).by(-1)
      end
    end
  end
end

