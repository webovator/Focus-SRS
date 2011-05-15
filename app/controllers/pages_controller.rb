class PagesController < ApplicationController
before_filter :authenticate_user!, :except => [:home]

  def home
  @title = "Home"
    if user_signed_in?
      @card = Card.new 
      @feed_items = current_user.feed.paginate(:page => params[:page])
     else
      @feed_items = []
      render 'pages/home'
    end


  end

  def about
  end

end