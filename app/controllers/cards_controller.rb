class CardsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy 
 
  def create
    @card = current_user.cards.build(params[:card])
    if @card.save
      flash[:success] = "Card created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @card.destroy
    redirect_back_or root_path
  end

  private

    def authorized_user
      @card = current_user.cards.find_by_id(params[:id])
      redirect_to root_path if @card.nil?
    end
end

