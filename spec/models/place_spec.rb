require 'spec_helper'

describe Place do
  
  before(:each) do
    @user = Factory(:user)
    @place_attr = {:googleid => "id1", :googleref => "ref1", :name => "name1"}
    @card_attr = {:comment => "value for comment", :place_attributes => @place_attr}
  end

  it "should create a new instance given valid attributes" do
    @user.cards.create!(@card_attr)
  end

  describe "card associations" do

    before(:each) do
      @place = Place.create(@place_attr)
    end

    it "should have a cards attribute" do
      @place.should respond_to(:cards)
    end
  end

  describe "validations" do

    it "should require nonblank googleid" do
      @wrong_place = {:googleid => " ", :googleref => "ref1", :name => "name1"}
      @user.cards.build(:comment => "a", :place_attributes => @wrong_place).should_not be_valid
    end

    it "should require nonblank googleref" do
      @wrong_place = {:googleid => "id1", :googleref => " ", :name => "name1"}
      @user.cards.build(:comment => "a", :place_attributes => @wrong_place).should_not be_valid
    end

    it "should require nonblank name" do
      @wrong_place = {:googleid => "id1", :googleref => "ref1", :name => " "}
      @user.cards.build(:comment => "a", :place_attributes => @wrong_place).should_not be_valid
    end

    it "should be only one place with the same googleid" do
      @place1 = Place.create(@place_attr)
      @place2 = Place.create(@place_attr).should_not be_valid
    end
  end
end
