class CreateJoinTablePlayersMoves < ActiveRecord::Migration
  def change
    create_join_table :players, :moves do |t|
      t.index [:player_id, :move_id]
      t.index [:move_id, :player_id]
    end
  end
end
