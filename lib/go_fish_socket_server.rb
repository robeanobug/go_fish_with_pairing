require 'socket'

class GoFishSocketServer
  attr_accessor :server, :clients, :players, :lobby
  attr_reader :port_number
  def initialize
    @port_number = 3336
    @clients = []
    @players = []
  end

  def accept_new_client(player_name = 'Random Player')
    client = server.accept_nonblock
    players << player_name
    clients << client
    client.puts 'Welcome to Go Fish!'
  rescue IO::WaitReadable, Errno::EINTR
    puts 'No client to accept'
  end

  def create_game_if_possible
    if players.count > 1
      send_message_to_all_clients('Game is starting...')
    end
  end

  def start
    self.server = TCPServer.new(port_number)
  end
  
  def stop
    server.close if server
  end

  private

  def send_message_to_all_clients(message)
    clients.each { |client| client.puts message}
  end
end