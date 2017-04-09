class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
			t.integer :moves_completed, default: 0, null: false
			t.jsonb :positions, default: nil
			t.timestamps
    end
  end
end



