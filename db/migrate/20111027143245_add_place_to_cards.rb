class AddPlaceToCards < ActiveRecord::Migration
  def change
    add_column :cards, :place_id, :integer
    add_index :cards, [:place_id, :created_at]
  end
end
