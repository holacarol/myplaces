require 'spec_helper'

describe Card do

  before(:each) do
    @user = Factory(:user)
    @attr = { :comment => "value for comment" }
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
      @user.cards.build(:comment => "  ").should_not be_valid
    end

    it "should reject long comment" do
      @user.cards.build(:comment => "a" * 141).should_not be_valid
    end
  end
end

