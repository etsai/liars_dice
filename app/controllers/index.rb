require 'pry'

@client = Twilio::REST::Client.new(ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN'])
@current_player = nil
@current_game = nil

post '/' do
  if player_playing?(params[:From])
    bid?(params[:Body][0]) ? game_move(params[:Body], params[:From]) : game_menu(params[:Body], params[:From])
  else
    pregame_menu(params[:Body], params[:From])
  end
end

get '/' do
  erb :index
end