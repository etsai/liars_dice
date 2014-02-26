def pregame_menu(body, phone_number)
  parse_incoming_commands(body)
  case @keywords[:command]
  when "create"
    @current_game = Game.create(name: @keywords[:name], next_player: phone_number)
    @current_game.players << Player.create(phone_number: phone_number)
    join_successful(@current_game.name)
  else
    if game_exists?(@keywords[:command])
      add_player(phone_number)
      join_successful(@current_game.name)
    else
      instructions()
    end
  end
end

def game_menu(body, phone_number)
  parse_incoming_commands(body)
  @current_game = Game.find(@current_player.game_id)
  case @keywords[:command]
  when "start"
    round_begins()
  when "call"
    @current_player.call(@current_game)
    announce_loser(@current_game.loser)
    notify_player_out(@current_game.loser) if @current_game.loser.hand == 0
    if check_winner?
      announce_winner(winner_name)
      @current_game.destroy
    else
      round_begins()
    end
  else
    @current_player.set_player_name(params[:Body])
  end
end

def game_move(text)
  @current_game = Game.find(@current_player.game_id)
  @current_game.next_player == phone_number ? player_bidding(text) : wrong_turn()
end

def player_bidding(text)
  response = text.split(' ')
  response[1].gsub!(/[s]/, '')
  incoming_bid = Bid.new(response)
  if validate_incoming_bid(incoming_bid)
    @current_game.set_new_bid(incoming_bid)
    announce_bid()
    @current_game.set_next_player(@current_player)
    notify_next_player(@current_game.next_player)
  else
    text_invalid_bid()
  end
end

def bid?(body)
  body =~ /[0-9]/
end

def round_begins
  @current_game.start_round()
  notify_game_state()
  notify_next_player(@current_game.next_player)
end

def validate_incoming_bid(new_bid)
  new_bid > @current_game.current_bid
end

def parse_incoming_commands(text)
  responses = text.split(' ')
  @keywords = Hash.new
  @keywords[:command] = responses[0].downcase
  @keywords[:name] = responses[1]
end

def player_playing?(phone_number)
  players = Player.where(phone_number: phone_number)
  @current_player = players.first if players.any?
end

def game_exists?(title)
  games = Game.where(name: title)
  @current_game = games.first if games.any?
end

def add_player(phone_number)
  @current_game.players << Player.create(phone_number: phone_number)
end

def check_winner?
  @current_game.current_players.size == 1
end

def winner_name
  @current_game.current_players.first.name
end