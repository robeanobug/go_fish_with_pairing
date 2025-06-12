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
    setup_game_with_players
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  let(:client1) { MockGoFishSocketClient.new(@server.port_number) }
  let(:client2) { MockGoFishSocketClient.new(@server.port_number) }
  
  let(:players) { @server.players }
  let(:player1) { players.first }
  let(:player2) { players.last }
  let(:lobby) {@server.lobbies.first }
  # let(:game) { @server.games.first }

  it 'outputs every players hand to every player' do
    lobby.play_round

    expect(client1.capture_output).to match /Your cards/i
    expect(client2.capture_output).to match /Your cards/i
  end

  it 'gets a card rank request from the current player' do
    lobby.play_round

    expect(client1.capture_output).to match /Please request a card rank/i
  end

  it 'displays the opponents' do
    lobby.play_round

    expect(client1.capture_output).to match /opponents:/i
  end

  it 'gets a target player from the current player' do
    lobby.play_round
    
    expect(client1.capture_output). to match /Which opponent would you like to request from:/i
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
