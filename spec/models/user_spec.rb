require 'spec_helper'

describe User do

  before(:each) do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 129
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "valid_password? method" do

      it "should be true if the passwords match" do
        @user.valid_password?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.valid_password?("invalid").should be_false
      end 
    end
  end

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "card associations" do

    before(:each) do
      @user = User.create(@attr)
      @place1 = Factory(:place, :googleid => "id1", :googleref => "ref1", :name => "Name1")
      @place2 = Factory(:place, :googleid => "id2", :googleref => "ref2", :name => "Name2")
      @card1 = Factory(:card, :user => @user, :place => @place1, :created_at => 1.day.ago)
      @card2 = Factory(:card, :user => @user, :place => @place2, :created_at => 1.hour.ago)
    end

    it "should have a cards attribute" do
      @user.should respond_to(:cards)
    end

    it "should have the right cards in the right order" do
      @user.cards.should == [@card2, @card1]
    end

    it "should destroy associated cards" do
      @user.destroy
      [@card1, @card2].each do |card|
        Card.find_by_id(card.id).should be_nil
      end
    end

    describe "status feed" do

      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should include the user's cards" do
        @user.feed.include?(@card1).should be_true
        @user.feed.include?(@card2).should be_true
      end

      it "should not include a different user's cards" do
        @place3 = Factory(:place, :googleid => "id3", :googleref => "ref3", :name => "Name3")
        card3 = Factory(:card,
                      :user => Factory(:user, :email => Factory.next(:email)), :place => @place3)
        @user.feed.include?(card3).should be_false
      end
    end
  end

end
