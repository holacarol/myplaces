class Card < ActiveRecord::Base
  attr_accessible :comment
  
  belongs_to :user

  validates :comment, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true

  default_scope :order => 'cards.created_at DESC'
end
