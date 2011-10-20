class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  has_many :cards, :dependent => :destroy

  validates :name, :presence => true,
		   :length   => { :maximum => 50 }


  def feed
    # This is preliminary. See Chapter 12 for the full implementation.
    Card.where("user_id = ?", id)
  end
end
