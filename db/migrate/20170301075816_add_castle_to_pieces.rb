class AddCastleToPieces < ActiveRecord::Migration
  def change
    add_column :pieces, :castle, :boolean
  end
end
