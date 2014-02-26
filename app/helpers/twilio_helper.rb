def instructions
  twiml = Twilio::TwiML::Response.new do |r|
  r.Message "Welcome to Liar's Dice. To start a game text 'create [title of game]' otherwise text the title of the game you want to join and your name."
  end
  twiml.text
end

def join_successful(name)
  twiml = Twilio::TwiML::Response.new do |r|
    r.Message "Welcome to Liar's Dice! You created a game called #{name}. What is your name?"
    r.Message "When all your friends have joined your game text 'Start' to begin."
  end
  twiml.text
end

def notify_game_state
  @current_game.players.each do |player|
    message = @client.account.messages.create(
    :body => "There are currently #{@current_game.num_of_players} players in the game with a total of #{@current_game.dice_in_game} dice.",
    :to => player.phone_number,
    :from => "+12029993423")
  end
end

def notify_next_player(phone_number)
  message = @client.account.messages.create(
    :body => "It's your turn. Make a bid or a 'Call'.",
    :to => phone_number,
    :from => "+12029993423"
  )
end

def announce_bid
  @current_game.players.each do |player|
    message = @client.account.messages.create(
      :body => "The current bid is #{@current_game.current_bid[:count]}, #{@current_game.current_bid[:face]}s",
      :to => player.phone_number,
      :from => "+12029993423"
    )
  end
end

def wrong_turn
  twiml = Twilio::TwiML::Response.new do |r|
    r.Message "Whoops! It's not your turn."
  end
  twiml.text
end

def announce_loser(loser)
  @current_game.players.each do |player|
  message = @client.account.messages.create(
    :body => "#{loser.name} lost. The pool of dice was #{@current_game.dice_count}",
    :to => player.phone_number,
    :from => "+12029993423"
  )
  end
end

def notify_player_out(loser)
  message = @client.account.messages.create(
    :body => "You have no more dice. Better luck next time.",
    :to => loser.phone_number,
    :from => "+12029993423"
  )
end

def announce_winner(winner)
  @current_game.players.each do |player|
  message = @client.account.messages.create(
    :body => "#{winner} WON!",
    :to => player.phone_number,
    :from => "+12029993423"
  )
  end
end

def text_invalid_bid
  message = CLIENT.account.messages.create(
    :body => "That's not a valid bid. The current bid is #{@current_game.current_bid[:count]}, #{@current_game.current_bid[:face]}s. Please try again.",
    :to => @current_player.phone_number,
    :from => "+12029993423"
  )
end