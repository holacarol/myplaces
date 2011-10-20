class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.text :comment
      t.references :user

      t.timestamps
    end
    add_index :cards, [:user_id, :created_at]
  end
end
