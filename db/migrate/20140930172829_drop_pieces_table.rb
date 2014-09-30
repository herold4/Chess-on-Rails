class DropPiecesTable < ActiveRecord::Migration
  def change
    drop_table :pieces
  end
end
