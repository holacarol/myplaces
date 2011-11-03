class Card < ActiveRecord::Base
  attr_accessible :comment, :place_attributes
  
  belongs_to :user
  belongs_to :place, :autosave => true

  accepts_nested_attributes_for :place, :reject_if => :all_blank

  validates :comment, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  validates_uniqueness_of :place_id, :scope => :user_id, :message => "You already got this one!"

  default_scope :order => 'cards.created_at DESC'

# Solution to the problem: If place already exists, get the associated id.
# Other solution to consider: Find the existing place in the controller or not use the nested_attributes

  def validate_associated_records_for_place
    if place.googleid.blank?
      errors.add(:googleid, "can't be empty")
    end
    if place.googleref.blank?
      errors.add(:googleref, "can't be empty")
    end
    if place.name.blank?
      errors.add(:name, "can't be empty")
    end
  end
    

  def autosave_associated_records_for_place
    if new_place = Place.find_by_googleid(place.googleid) then
      self.place = new_place
    else
      self.place.save!
      self.place_id = place.id
    end
    self.valid?
  end
end
