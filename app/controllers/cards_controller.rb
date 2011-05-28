class CardsController < ApplicationController
before_filter :authenticate_user!
  def show
    @card = Card.find(params[:id])
  end
  
  def index
  @title = "Cards"
    @cards = Card.search(params[:search]).paginate(:per_page => 10, :page => params[:page])
  end

  def new
    @card = Card.new
    @title = "New Cards"
  end
  
  def copy
    @card = Card.find(params[:id])
    @bear = @card.clone
    @bear.update_attribute(:user_id, current_user.id)
    @bear.save
    flash[:success] = "Card '#{@card.card_front}' added to your deck!"
    redirect_to cards_path
  end


  def create
    @card = current_user.cards.build(params[:card])
    if @card.save
     flash[:success] = "Card #{@card.card_front} successfully added!"
     redirect_to root_path
    else
      @title = "Add Cards"
      render 'new'
    end
  end
  
  def edit
    @card = Card.find(params[:id])
    @title = "Edit Card"
  end
  
  def update
    @card = Card.find(params[:id])
   
   if params[:zero]
     @card.zerobutton
   end
   
   if params[:one]
    @card.onebutton
   end
   
   if params[:two] 
    @card.twobutton
   end
 
    if params[:three] 
    @card.threebutton
   end 
   
   if params[:four] 
     @card.fourbutton
   end
   
   if params[:five] 
    @card.fivebutton
   end

  if @card.update_attributes(params[:card]) 
     if params[:five] || params[:four] || params[:three] || params[:two] || params[:one] || params[:zero]
     flash[:success] = "Card #{@card.card_front} reviewed! Days until next review: #{@card.day_interval.floor}"
     redirect_to reviewcards_path
    else 
    if  params[:copy]
    flash[:success] = "Card #{@card.card_front} is yours!"
    redirect_to root_path
    end
    if @card.new_record?
        flash[:success] = "Card #{@card.card_front} successfully added!"
        redirect_to root_path
      else 
        flash[:success] = "Card #{@card.card_front} successfully updated!"
        redirect_to root_path
      end
    end
  end
end


    
def review #belongs in user controller? 
   if Card.where("review_date <= ? AND user_id = ?", Date.today, current_user.id).empty?
     flash[:success] = "Great Job! All cards for today have been reviewed!"
     redirect_to root_path
   else
    @card = Card.where("review_date <= ? AND user_id = ?", Date.today, current_user.id).first 
    @title = "Review Card"
   end
  end
   
   def showback
    @card = Card.where("review_date <= ? AND user_id = ?", Date.today, current_user.id).first 
    @title = "Review Card"
   end
  
  def card_index
    @users = User.all
    @title = "All users"
    @cards = Card.search(params[:search]).paginate(:page => params[:page])
   end

  def destroy
    @card = Card.find(params[:id]).destroy
    flash[:success] = "Card Deleted!"
    redirect_to root_path
  end
end
