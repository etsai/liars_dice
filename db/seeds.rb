require 'faker'

Player.create :phone_number => "2078414568", :game_id => 1

2.times do
  Game.create :name => Faker::Lorem.word
end

5.times do
  Player.create :phone_number => Faker::PhoneNumber.cell_phone, :game_id => rand(1..2)
end