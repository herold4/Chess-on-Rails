class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
			t.integer :game_id, null: false
			t.integer :ordinal, null: false, default: 0
			t.integer :player_id, null: false
			t.timestamps
			t.references :games, constraint: true
    end
		add_index :moves, [:game_id, :ordinal], unique: true
  end
end