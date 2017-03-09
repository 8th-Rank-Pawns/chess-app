class AddDefaultToPassant < ActiveRecord::Migration
  def change
    change_column :pieces, :passant, :boolean, default: false
  end
end
