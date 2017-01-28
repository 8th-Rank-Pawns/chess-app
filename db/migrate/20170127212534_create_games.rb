class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
    	t.integer :white_player
    	t.integer :black_player
    	t.string :name
    	
      t.timestamps
    end
  end
end
