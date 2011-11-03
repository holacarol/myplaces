class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :googleid
      t.string :googleref
      t.string :name

      t.timestamps
    end
    add_index :places, [:googleid, :googleref]
  end
end
