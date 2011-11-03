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
    place_attr = Factory.attributes_for(:place) 
    comment = "Lorem ipsum dolor sit amet"

    describe "failure" do
    
      it "should not make a new card without a comment" do
        lambda do
          visit root_path
          fill_in :card_place_attributes_googleid, :with => place_attr[:googleid]
          fill_in :card_place_attributes_googleref, :with => place_attr[:googleref]
          fill_in :card_place_attributes_name, :with => place_attr[:name]
          fill_in :card_comment, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Card, :count)
      end

      it "should not make a new card without a place.googleid" do
        lambda do
          visit root_path
	  fill_in :card_place_attributes_googleid, :with => ""
          fill_in :card_place_attributes_googleref, :with => place_attr[:googleref]
          fill_in :card_place_attributes_name, :with => place_attr[:name]
          fill_in :card_comment, :with => comment
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Card, :count)
      end

      it "should not make a new card without a place.googleref" do
        lambda do
          visit root_path
          fill_in :card_place_attributes_googleid, :with => place_attr[:googleid]
          fill_in :card_place_attributes_googleref, :with => ""
          fill_in :card_place_attributes_name, :with => place_attr[:name]
          fill_in :card_comment, :with => comment
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Card, :count)
      end

      it "should not make a new card without a place.name" do
        lambda do
          visit root_path
          fill_in :card_place_attributes_googleid, :with => place_attr[:googleid]
          fill_in :card_place_attributes_googleref, :with => place_attr[:googleref]
          fill_in :card_place_attributes_name, :with => ""
          fill_in :card_comment, :with => comment
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
          fill_in :card_place_attributes_googleid, :with => place_attr[:googleid]
          fill_in :card_place_attributes_googleref, :with => place_attr[:googleref]
          fill_in :card_place_attributes_name, :with => place_attr[:name]
          fill_in :card_comment, :with => comment
          click_button
          response.should have_selector("span.comment", :content => comment)
        end.should change(Card, :count).by(1)
      end
    end
  end
end

