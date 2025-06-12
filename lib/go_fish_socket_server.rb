require 'socket'
require_relative 'go_fish_game'
require_relative 'go_fish_lobby'
require_relative 'player'

class GoFishSocketServer
  attr_accessor :server, :clients, :players, :lobbies, :games, :sent_message_to_all_clients
  attr_reader :port_number
  def initialize
    @port_number = 3336
    @clients = []
    @players = []
    @games = []
    @lobbies = []
  end

  def accept_new_client(player_name=nil)
    client = server.accept_nonblock
    player_name = get_player_name(client) unless player_name
    players << Player.new(player_name)
    clients << client
    client.puts 'Welcome to Go Fish!'
  rescue IO::WaitReadable, Errno::EINTR
    puts 'No client to accept'
  end

  def create_game_if_possible
    if players.count > 1
      game = GoFishGame.new(players)
      games << game
      lobbies << GoFishLobby.new(game, players_clients)
      send_message_to_all_clients('Game is starting...')
    end
  end

  def players_clients
    players.zip(clients).to_h
  end

  def start
    self.server = TCPServer.new(port_number)
  end
  
  def stop
    server.close if server
  end

  private

  def get_player_name(client)
    client.puts 'What is your name?'
    name = listen_to_client(client)
    client.puts "Hello, #{ name }"
  end

  def send_message_to_all_clients(message)
    clients.each { |client| client.puts message} unless sent_message_to_all_clients
    self.sent_message_to_all_clients = true
  end

  def listen_to_client(client, delay=0.1)
    sleep(delay)
    client.read_nonblock(200_000).chomp
  rescue IO::WaitReadable
    nil
  end
end