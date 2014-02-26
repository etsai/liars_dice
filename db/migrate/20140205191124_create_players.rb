class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :phone_number
      t.integer :hand, default: 5
      t.belongs_to :game
    end
  end
end
