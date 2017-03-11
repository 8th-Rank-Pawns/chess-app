class AddPassantToPieces < ActiveRecord::Migration
  def change
    add_column :pieces, :passant, :boolean
  end
end
