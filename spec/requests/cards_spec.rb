require 'spec_helper'

describe "Cards" do

  before(:each) do
    user = Factory(:user)
    visit new_user_session_path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
  end
  
  describe "creation" do
    
    describe "failure" do
    
      it "should not make a new card" do
        lambda do
          visit root_path
          fill_in :card_comment, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Card, :count)
      end
    end

    describe "success" do
  
      it "should make a new card" do
        comment = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :card_comment, :with => comment
          click_button
          response.should have_selector("span.comment", :content => comment)
        end.should change(Card, :count).by(1)
      end
    end
  end
end

