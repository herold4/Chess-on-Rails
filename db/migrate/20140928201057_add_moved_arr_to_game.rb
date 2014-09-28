class AddMovedArrToGame < ActiveRecord::Migration
  def change
    add_column :games, :white_moved, :string
    add_column :games, :black_moved, :string
  end
end
