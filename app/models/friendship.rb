class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"

  validates_presence_of :user_id, :friend_id
  
  # "def self." means this is a class method
  # Return true if the users are (possibly pending) friends.
  def self.exists?(user, friend)
    not find_by_user_id_and_friend_id(user, friend).nil?
  end
  
  # Record a pending friend request.
  def self.request(user, friend)
    unless user == friend or Friendship.exists?(user, friend)
      transaction do
        create(:user => user, :friend => friend, :status => 'pending')
        create(:user => friend, :friend => user, :status => 'requested')
      end
    end
  end

  # Accept a friend request.
  def self.accept(user, friend)
    transaction do
      accept_one_side(user, friend)
      accept_one_side(friend, user)
    end
  end


  # Delete a friendship or cancel a pending request.
  def self.breakup(user, friend)
    transaction do
      destroy(find_by_user_id_and_friend_id(user, friend))
      destroy(find_by_user_id_and_friend_id(friend, user))
    end
  end


  private
  
  # Update the db with one side of an accepted friendship request.
  def self.accept_one_side(user, friend)
    request = find_by_user_id_and_friend_id(user, friend)
    request.status = 'accepted'
    request.save!
  end

end
