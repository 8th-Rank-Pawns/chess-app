class AddActiveTurnColumn < ActiveRecord::Migration
  def change
    add_column :games, :active_turn, :string
    add_index :games, :active_turn
  end
end
