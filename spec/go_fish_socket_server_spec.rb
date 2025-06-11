require 'socket'
require_relative '../lib/go_fish_socket_server'
require_relative '../lib/mock_go_fish_socket_client'

describe GoFishSocketServer do
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

  it 'sends clients a welcome message' do
    @clients.push(client1)
    @server.accept_new_client('Player 1')

    @clients.push(client2)
    @server.accept_new_client('Player 2')

    expect(client1.capture_output).to match /welcome/i
    expect(client2.capture_output).to match /welcome/i
  end

  it 'outputs game is starting to clients' do
    @clients.push(client1)
    @server.accept_new_client('Player 1')

    @clients.push(client2)
    @server.accept_new_client('Player 2')
    @server.create_game_if_possible

    expect(client1.capture_output).to match /game is starting/i
    expect(client2.capture_output).to match /game is starting/i
  end

  it 'creates a game runner room for the players to play the game in' do
    @clients.push(client1)
    @server.accept_new_client('Player 1')

    @clients.push(client2)
    @server.accept_new_client('Player 2')
    @server.create_game_if_possible

    expect(client)
  end
end
