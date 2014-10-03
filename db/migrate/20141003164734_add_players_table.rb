class AddPlayersTable < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :game_id
      t.boolean :white
      t.string :captured
      t.timestamps
    end
  end
end


