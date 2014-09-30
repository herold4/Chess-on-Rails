class DropBoardsTable < ActiveRecord::Migration
  def change
    drop_table :boards
  end
end
