require 'socket'
require_relative '../lib/go_fish_socket_server'
require_relative '../lib/mock_go_fish_socket_client'

RSpec.describe GoFishSocketServer do
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

  it 'is not listening on a port before it is started' do
    @server.stop
    expect { MockGoFishSocketClient.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
  end

  it 'accepts a new client' do
    player_count = 1
    @clients.push(client1)
    @server.accept_new_client('Player 1')

    expect(@server.players.count).to eq(player_count)
  end

  it 'asks for a player name' do
    @clients.push(client1)
    @server.accept_new_client
    expect(client1.capture_output).to match /name/i
  end

  it 'displays name back to the player' do
    name = "Player"
    @clients.push(client1)
    client1.provide_input(name)
    @server.accept_new_client
    expect(client1.capture_output).to include name
  end

  it 'sends clients a welcome message' do
    setup_game_with_players

    expect(client1.capture_output).to match /welcome/i
    expect(client2.capture_output).to match /welcome/i
  end

  it 'outputs game is starting to clients once' do
    setup_game_with_players

    expect(client1.capture_output).to match /game is starting/i
    expect(client2.capture_output).to match /game is starting/i
    @server.create_game_if_possible
    expect(client1.capture_output).to_not match /game is starting/i
    expect(client2.capture_output).to_not match /game is starting/i
  end

  it 'creates a game to play the game in' do
    setup_game_with_players

    expect(@server.games.length).to eq(1)
  end

  it 'creates a game lobby' do
    setup_game_with_players

    expect(@server.lobbies.length).to be 1
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
