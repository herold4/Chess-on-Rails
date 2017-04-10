class PlayersGames < ActiveRecord::Migration
  def change
    create_table :players_games do |t|
			t.integer :player_id, null: false
			t.integer :game_id
			t.boolean :is_white, null: false
			t.timestamps
			t.references :players, constraint: true
			t.references :games, constraint: true
    end
		add_index :players_games, [:player_id, :game_id]
		add_index :players_games, [:game_id, :player_id]
  end
end
