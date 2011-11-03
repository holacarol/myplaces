class Place < ActiveRecord::Base
  attr_accessible :googleid, :googleref, :name

  has_many :cards

  validates :googleid, :presence => true, :uniqueness => true
  validates :googleref, :presence => true
  validates :name, :presence => true

end
