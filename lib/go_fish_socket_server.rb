require 'socket'

class GoFishSocketServer
  attr_accessor :server, :clients, :players
  attr_reader :port_number
  def initialize
    @port_number = 3336
    # @games = []
    @clients = []
    @players = []
  end

  def accept_new_client(player_name)
    client = server.accept_nonblock
    players << player_name
    clients << client
  end

  def start
    self.server = TCPServer.new(port_number)
  end
  
  def stop
    server.close if server
  end
end