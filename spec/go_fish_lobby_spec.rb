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
  let(:lobby) { @server.lobbies.first }
  # let(:game) { @server.games.first }
  describe '#play_round' do
    it 'outputs every players hand to every player once' do
      lobby.play_round
      expect(client1.capture_output).to match /Your cards/i
      expect(client2.capture_output).to match /Your cards/i
      lobby.play_round
      expect(client1.capture_output).to_not match /Your cards/i
    end
  
    it 'requests a card rank from the current player once' do
      lobby.play_round
      expect(client1.capture_output).to match /Please request a card rank/i
      lobby.play_round
      expect(client1.capture_output).to_not match /Please request a card rank/i
    end
    
    describe 'getting a rank' do
      before do
        client1.provide_input('Ace')
        lobby.play_round
      end

      it 'gets a card rank request from the current player' do
        expect(client1.capture_output).to match /You requested: Ace/i
        lobby.play_round
        expect(client1.capture_output).to_not match /You requested:/i
      end
    end
    
    describe 'getting an opponent' do
      before do
        client1.provide_input('Ace')
        lobby.play_round
        client1.provide_input('Player 2')
        lobby.play_round
      end

      it 'displays the opponents once' do
        expect(client1.capture_output).to match /opponents:/i
        lobby.play_round
        expect(client1.capture_output).to_not match /opponents:/i
      end
    
      it 'requests a target player from the current player once' do
        expect(client1.capture_output).to match /Which opponent would you like to request from:/i
        lobby.play_round
        expect(client1.capture_output).to_not match /Which opponent would you like to request from:/i
      end
    end

    describe 'displaying results' do
      context 'when player has input rank and opponent' do
        before do
          client1.provide_input('Ace')
          lobby.play_round
          client1.provide_input('Player 2')
          lobby.play_round
        end

        it 'displays round results to players' do
          expect(client1.capture_output).to match /result/i
        end
      end

      context 'when player has input rank but not opponent' do
        before do
          client1.provide_input('Ace')
          lobby.play_round
        end

        it 'displays round results to players' do
          expect(client1.capture_output).to_not match /result/i
        end
      end

      context 'when player has not input anything' do
        before do
          lobby.play_round 
        end
        
        it 'displays round results to players' do
          expect(client1.capture_output).to_not match /result/i
        end
      end
    end
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
