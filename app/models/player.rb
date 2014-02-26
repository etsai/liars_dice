class Player < ActiveRecord::Base
  belongs_to :game
  validates :phone_number, presence: true

  def set_player_name(name)
    self.name = name
    self.save
  end

  def lose
    self.hand -= 1
    self.save
  end

  def call(game)
    bid_face = game.current_bid[:face]
    bid_count = game.current_bid[:count]
    if game.dice_count[1] + game.dice_count[bid_face] < bid_count
      last_player_index = game.current_players.find_index(self) - 1
      last_player = game.current_players[last_player_index]
      last_player.lose()
      game.loser = last_player
    else
      self.lose()
      game.loser = self
    end
  end

end