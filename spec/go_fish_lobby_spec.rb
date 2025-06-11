require 'spec_helper'
require_relative '../lib/go_fish_lobby'
require_relative '../lib/go_fish_socket_server'
require_relative '../lib/mock_go_fish_socket_client'

RSpec.describe GoFishLobby do
  before(:each) do
    @clients = []
    @server = GoFishSocketServer.new
    @server.start
    sleep 0.1
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  let(:client1) { MockGoFishSocketClient.new(@server.port_number) }
  let(:client2) { MockGoFishSocketClient.new(@server.port_number) }

  let(:player1) { @server.players.first }
  let(:player2) { @server.players.last }
  let(:players) { [player1, player2] }
  # let(:game) { @server.game }
  
  it 'initializes with players_clients' do
    setup_game_with_players
    
    expect(@server.lobbies.first.players_clients[player1]).to eq(@server.clients.first)
  end

  private

  def setup_game_with_players
    @clients.push(client1)
    @server.accept_new_client('Player 1')

    @clients.push(client2)
    @server.accept_new_client('Player 2')

    @server.create_game_if_possible
  end
end
