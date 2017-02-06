class RemovePieceTypeFromPieces < ActiveRecord::Migration
  def change
    remove_column :pieces, :piece_type, :integer
  end
end
