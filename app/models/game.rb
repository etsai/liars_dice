class Game < ActiveRecord::Base
  has_many :players, dependent: :destroy
  validates :name, presence: true
  serialize :dice_count, Hash
  serialize :current_bid, Hash

  attr_accessor :loser, :winner

  def start_round
    @dice_count = {1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0}
    current_players.each do |player|
      give_hand(player.hand)
      dice_collect(@hand)
      die_unicode(@hand)
      text_hand(player.phone_number, @hand)
    end
    self.dice_count = @dice_count
    self.current_bid = {face: 0, count: 0}
    self.save
  end

  def current_players
    self.players.reject { |player| player.hand == 0 }
  end

  def num_of_players
    current_players.size
  end

  def set_new_bid(bid)
    self.current_bid = {face: bid.face, count: bid.count}
    self.save
  end

  def set_next_player(current)
    next_player_index = self.current_players.find_index(current) + 1
    if next_player_index == current_players.size
      self.next_player = current_players[0].phone_number
      self.save
    else
      self.next_player = current_players[next_player_index].phone_number
      self.save
    end
  end

  def dice_in_game
    dice_in_play = 0
    self.players.each do |player|
      dice_in_play += player.hand
    end
    return dice_in_play
  end

  def dice_collect(hand)
    hand.each do |die|
      @dice_count[die] += 1
    end
  end

  def give_hand(size)
    @hand = []
    size.times do
      @hand << rand(6)+1
    end
  end

  def die_unicode(hand)
    hand.map! { |i| getdie(i) }
  end

  def getdie(i)
    [i + 0x267f].pack("U*")
  end

  def text_hand(phone_number, hand)
    message = CLIENT.account.messages.create(
      :body => hand.join(" "),
      :to => phone_number,
      :from => "+12029993423")
  end
end