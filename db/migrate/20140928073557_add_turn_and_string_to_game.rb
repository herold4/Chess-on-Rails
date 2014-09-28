class AddTurnAndStringToGame < ActiveRecord::Migration
  def change
    add_column :games, :state, :string
    add_column :games, :turn, :string
  end
end
