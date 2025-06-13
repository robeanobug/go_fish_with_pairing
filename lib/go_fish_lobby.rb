require_relative 'go_fish_game'
require_relative 'go_fish_socket_server'
require_relative 'player'

class GoFishLobby
  attr_reader :game, :players_clients
  attr_accessor :displayed_hand, :requested_card_rank, :rank, :displayed_opponents, :requested_opponent, :opponent
  def initialize(game, players_clients)
    @game = game
    @players_clients = players_clients
  end

  def run_game
    loop do
      run_round
    end
  end

  def run_round
    display_hands unless displayed_hand
    get_rank if displayed_hand && !rank
    display_opponents if rank && !displayed_opponents
    get_opponent if rank && !opponent
    play_round(rank, opponent) if rank && opponent
    display_result if rank && opponent
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

  def bystanders
    (players - [current_player]) - [opponent]
  end

  def current_client
    players_clients[current_player]
  end

  def opponent_client
    players_clients[opponents.first]
  end

  def display_hands
    clients.each do |client|
      client.puts "Your cards: #{ get_cards(clients_players[client]) }"
    end
    self.displayed_hand = true
  end

  def get_cards(player)
    player.hand.map { |card| "#{card.rank} of #{card.suit}" }
  end

  def get_rank
    current_client.puts 'Please request a card rank: ' unless requested_card_rank
    self.requested_card_rank = true
    self.rank = valid_rank(listen_to_current_client)
    # self.requested_rank
    current_client.puts "You requested: #{rank}" if rank
  end

  def valid_rank(rank)
    rank = rank&.capitalize
    return rank if PlayingCard::RANKS.include?(rank)
  end

  def listen_to_current_client(delay=0.1)
    sleep(delay)
    current_client.read_nonblock(200_000).chomp
  rescue IO::WaitReadable
    nil
  end

  def display_opponents
    current_client.puts "Your opponents: #{ opponents.map(&:name) }" unless displayed_opponents
    self.displayed_opponents = true
  end

  def opponents
    players - [current_player]
  end

  def get_opponent
    current_client.puts 'Which opponent would you like to request from:' unless requested_opponent
    self.requested_opponent = true
    self.opponent = valid_player(listen_to_current_client)
  end

  def valid_player(player_name)
    players.find do |player|
      player.name.downcase == player_name&.downcase
    end
  end

  def play_round(rank, opponent)
    # need to move this into game class along with tests
    go_fish unless take_cards(rank, opponent)
  end

  def take_cards(rank, opponent)
    cards = opponent.hand.select { |card| card.rank == rank }
    unless cards.empty?
      opponent.remove_cards(cards)
      return current_player.add_cards(cards)
    end
    false
  end

  def go_fish
    current_player.add_cards(deal_card)
  end

  def deal_card
    game.deal_card
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