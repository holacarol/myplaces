class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => :show
  before_filter :admin_user,         :only => :destroy

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @cards = @user.cards.paginate(:page => params[:page])
    @title = @user.name
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def friends
    @title = "Friends"
    @user = User.find(params[:id])
    @users = @user.friends.paginate(:page => params[:page])
    render 'show_friends'
  end

  def pending_friends
    @title = "Pending friends"
    @user = User.find(params[:id])
    @users = @user.pending_friends.paginate(:page => params[:page])
    render 'show_friends'
  end

  def requested_friends
    @title = "Requested friends"
    @user = User.find(params[:id])
    @users = @user.requested_friends.paginate(:page => params[:page])
    render 'show_friends'
  end



  private
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
