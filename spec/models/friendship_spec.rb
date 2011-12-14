require 'spec_helper'

describe Friendship do

  before(:each) do
    @user = Factory(:user)
    @friend = Factory(:user, :email => Factory.next(:email))

    @friendship = @user.friendships.build(:friend_id => @friend.id, :status => 'pending')
    @friendship2 = @friend.friendships.build(:friend_id => @user.id, :status => 'requested')
  end

  it "should create a new instance given valid attributes" do
    @friendship.save!
  end

  it "should create a new instance with reverted attributes" do
    @friendship2.save!
  end

  describe "friend methods" do

    before(:each) do
      @friendship.save
    end

    it "should have a user attribute" do
      @friendship.should respond_to(:user)
    end

    it "should have the right user" do
      @friendship.user.should == @user
    end

    it "should have a friend attribute" do
      @friendship.should respond_to(:friend)
    end

    it "should have the right friend" do
      @friendship.friend.should == @friend
    end
  end
  
  describe "validations" do

    it "should require a user_id" do
      @friendship.user_id = nil
      @friendship.should_not be_valid
    end

    it "should require a friend_id" do
      @friendship.friend_id = nil
      @friendship.should_not be_valid
    end
  end

  describe "relationship methods" do

    it "should have a exists? method" do
      Friendship.should respond_to(:exists?)
    end

    it "should have a request method" do
      Friendship.should respond_to(:request)
    end

    it "should have an accept method" do
      Friendship.should respond_to(:accept)
    end

    it "should have a breakup method" do
      Friendship.should respond_to(:breakup)
    end

    it "should not have a pending friend" do
      Friendship.exists?(@user, @friend).should_not be_true
    end

    describe "user requests a friend" do

      before(:each) do
        Friendship.request(@user, @friend)
      end

      it "should exist" do
        Friendship.exists?(@user, @friend).should be_true
      end

      it "should have a pending friend" do
        @user.pending_friends.should include(@friend)
      end
 
      it "should have a requested friend" do
        @friend.requested_friends.should include(@user)
      end
    end
    
    describe "friend accepts a user as a friend" do

      before(:each) do
        Friendship.request(@user, @friend)
        Friendship.accept(@user, @friend)
      end

      it "should have friend as a friend" do
        @user.friends.should include(@friend)
      end

      it "should have user as a friend" do
        @friend.friends.should include(@user)
      end
    end

    describe "user remove friend as a friend" do

      before(:each) do
        Friendship.request(@user, @friend)
        Friendship.accept(@user, @friend)
        Friendship.breakup(@user, @friend)
      end

      it "should remove friendship" do
        Friendship.exists?(@user, @friend).should_not be_true
      end
    end
  end
end
