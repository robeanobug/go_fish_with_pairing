require_relative 'go_fish_game'
require_relative 'go_fish_socket_server'

class GoFishLobby
  attr_reader :game, :players_clients
  # attr_accessor :opponent
  def initialize(game, players_clients)
    @game = game
    @players_clients = players_clients
  end

  def play_round
    display_hands
    get_rank
    display_opponents
    get_opponent
    display_result
  end

  private

  def clients
    players_clients.values
  end

  def players
    players_clients.keys
  end

  def clients_players
    players_clients.invert
  end

  def current_player
    game.current_player
  end

  def opponent
    game.opponent
  end

  def bystanders
    (players - [current_player]) - [opponent]
  end

  def current_client
    players_clients[current_player]
  end

  def opponent_client
    players_clients[opponent]
  end

  def display_hands
    clients.each do |client|
      client.puts "Your cards: #{ get_cards(clients_players[client]) } }"
    end
  end

  def get_cards(player)
    player.hand.map { |card| "#{card.rank} of #{card.suit}" }
  end

  def get_rank
    current_client.puts 'Please request a card rank: '
  end

  def display_opponents
    current_client.puts "Your opponents: #{ opponents }"
  end

  def opponents
    players - [current_player]
  end

  def get_opponent
    current_client.puts 'Which opponent would you like to request from:'
  end

  def display_result
    current_client.puts "Result: #{ result.current_player_result }"
    opponent_client.puts "Result: #{ result.opponent_result }"
    bystanders.each { |bystander| players_clients[bystander].puts "Result: #{ result.bystanders_result}" }
  end

  def result
    game.result
  end
end