class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me


validates_presence_of :name
validates_uniqueness_of :name, :email, :case_sensitive => false
attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :cards, :dependent => :destroy
  
  def feed
    # This is preliminary. See Chapter 12 for the full implementation.
    Card.where("user_id = ?", id)
  end

end