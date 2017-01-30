class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.integer :piece_type
      t.integer :vertical_position
      t.integer :horizontal_position
      t.integer :user_id
      t.integer :game_id

      t.timestamps
    end
  end
end
