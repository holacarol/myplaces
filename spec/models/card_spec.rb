require 'spec_helper'

describe Card do

  before(:each) do
    @user = Factory(:user)
    @place_attr = {:googleid => "id1", :googleref => "ref1", :name => "name1"}
    @attr = { :comment => "value for comment", :place_attributes => @place_attr }
  end

  it "should create a new instance given valid attributes" do
    @user.cards.create!(@attr)
  end

  describe "user associations" do
    
    before(:each) do
      @card = @user.cards.create(@attr)
    end

    it "should have a user attribute" do
      @card.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @card.user_id.should == @user.id
      @card.user.should == @user
    end
  end

  describe "validations" do

    it "should require a user id" do
      Card.new(@attr).should_not be_valid
    end

    it "should require nonblank comment" do
      @user.cards.build(:comment => "  ", :place_attributes => @place_attr).should_not be_valid
    end

    it "should reject long comment" do
      @user.cards.build(:comment => "a" * 141, :place_attributes => @place_attr).should_not be_valid
    end

    it "should reject two cards with the same place for the same user" do
      @user.cards.create!(@attr)
      @user.cards.create(@attr).should_not be_valid
    end
  end

  describe "place associations" do

    before(:each) do
      @place_attr = {:googleid => "id1", :googleref => "ref1", :name => "name1"}
      @card_attr = {:comment => "value for comment", :place_attributes => @place_attr}
      @card = @user.cards.create(@card_attr)
    end

    it "should have a place attribute" do
      @card.should respond_to(:place)
    end
  end
end

