class Bid
  attr_accessor :face, :count

  def initialize(bid)
    self.count = bid[0].to_i
    self.face = bid[1].to_i
  end

  def >(last_bid)
    if @count > last_bid[:count]
      true
    elsif @count == last_bid[:count] && @face > last_bid[:face]
      true
    else
      false
    end
  end

  def set_current_bid(player)
    @current_game = Game.find(player.game_id)
    @current_game.current_bid = {face: @face, count: @count}
  end
end