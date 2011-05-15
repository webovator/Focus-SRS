# == Schema Information
# Schema version: <timestamp>
#
# Table name: users
#
#  id            :integer         not null, primary key
#  card_front    :text
#  card_back     :text
#  day_interval  :integer
#  review_date   :date
#  audio         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Card < ActiveRecord::Base

belongs_to :user

attr_accessible :card_front, :card_back, :day_interval, :audio, :review_date, :setscore
mount_uploader :audio, AudioUploader

validates :card_front, :presence => true
validates :user_id, :presence => true

before_save :default_values
#after_save :reset_zero
  
  def default_values
    if self.new_record?
      self.review_date = Date.today.to_s 
      self.day_interval = 2
    else
        self.day_interval =  @salk + day_interval*@score unless @score.nil?
        self.review_date = Date.today + day_interval.day unless @score.nil?
    end
  end
  

 
  def zerobutton
    @score = 0.138
    @salk = 0
  end
  
  def onebutton
    @score = 0.381924
    @salk = 0
  end
  
  def twobutton
    @score = 0.618
     @salk = 0
  end
  
  def threebutton
    @score = 1.03744513
     @salk = 0
  end
  
  def fourbutton
    @score = 1.618
     @salk = 0
  end
  
  def fivebutton
    @score = 2.61832197
     @salk = 0
  end
  
def self.search(search)
  if search
    where('LOWER(card_front) LIKE ?', "%#{search.downcase}%")
  else
    scoped
  end
end


default_scope :order => 'cards.created_at DESC'

end
