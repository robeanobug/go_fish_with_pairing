require 'socket'
require_relative 'go_fish_game'
require_relative 'go_fish_lobby'
require_relative 'player'

class GoFishSocketServer
  attr_accessor :server, :clients_waiting, :clients_in_lobby, :players, :lobbies, :games, :sent_message_to_all_clients
  attr_reader :port_number
  def initialize
    @port_number = 3336
    @clients_waiting = []
    @clients_in_lobby = []
    @players = []
    @games = []
    @lobbies = []
  end

  def accept_new_client(player_name=nil)
    client = server.accept_nonblock
    clients_waiting << client
    client.puts 'Welcome to Go Fish!'
    client.puts 'What is your name:' 
    client
  rescue IO::WaitReadable, Errno::EINTR
    puts 'No client to accept'
  end

  def get_player_name
    clients_waiting.each do |client|
      name = listen_to_client(client)
      return if name.nil?
      move_clients_to_lobby(client)
      client.puts "Hello, #{ name }"
      players << Player.new(name)
    end
  end

  def create_game_if_possible
    if players.count > 1
      game = GoFishGame.new(players)
      games << game
      lobby = GoFishLobby.new(game, players_clients)
      lobbies << lobby
      send_message_to_all_clients('Game is starting...')
      lobby
    end
  end

  def players_clients
    players.zip(clients_in_lobby).to_h
  end

  def run_game(lobby)
    lobby.run_game
  end

  def start
    self.server = TCPServer.new(port_number)
  end
  
  def stop
    server.close if server
  end
  

  private

  def send_message_to_all_clients(message)
    unless sent_message_to_all_clients
      clients_in_lobby.each { |client| client.puts message}
    end
    self.sent_message_to_all_clients = true
  end

  def move_clients_to_lobby(client)
    self.clients_waiting -= [client]
    clients_in_lobby << client
  end

  def listen_to_client(client, delay=0.1)
    sleep(delay)
    client.read_nonblock(200_000).chomp
  rescue IO::WaitReadable
    nil
  end
end