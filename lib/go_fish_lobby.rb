require_relative 'go_fish_game'
require_relative 'go_fish_socket_server'

class GoFishLobby
  attr_reader :game, :players_clients
  def initialize(game, players_clients)
    @game = game
    @players_clients = players_clients
  end
end