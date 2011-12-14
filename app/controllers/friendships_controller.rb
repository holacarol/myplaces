class FriendshipsController < ApplicationController
  before_filter :authenticate_user!

  # Send a friend request.
  # We'd rather call this "request", but that's not allowed by Rails.
  def create
    @user = User.find(params[:friendship][:friend_id])
    Friendship.request(current_user, @user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def update
    @user = Friendship.find_by_id(params[:id]).friend
    if current_user.requested_friends.include?(@user)
      Friendship.accept(current_user, @user)
    end
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Friendship.find_by_id(params[:id]).friend
    if current_user.requested_friends.include?(@user)
      Friendship.breakup(current_user, @user)
    elsif current_user.pending_friends.include?(@user)
      Friendship.breakup(current_user, @user)
    elsif current_user.friends.include?(@user)
      Friendship.breakup(current_user, @user)
    end
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

end
