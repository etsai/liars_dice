class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :current_bid
      t.string :next_player
      t.text :dice_count
    end
  end
end
