class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
			t.string :name, null: false
			t.integer :current_game_id
			t.string :session_token
    end
  end
end