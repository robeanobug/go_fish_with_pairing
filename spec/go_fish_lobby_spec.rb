require 'spec_helper'
require_relative '../lib/go_fish_lobby'
require_relative '../lib/go_fish_socket_server'
require_relative '../lib/mock_go_fish_socket_client'
require_relative '../lib/playing_card'

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

  describe '#run_round' do
    it 'outputs every players hand to every player once' do
      lobby.run_round
      expect(client1.capture_output).to match /Your cards/i
      expect(client2.capture_output).to match /Your cards/i
      lobby.run_round
      expect(client1.capture_output).to_not match /Your cards/i
    end
  
    it 'requests a card rank from the current player once' do
      lobby.run_round
      expect(client1.capture_output).to match /Please request a card rank/i
      lobby.run_round
      expect(client1.capture_output).to_not match /Please request a card rank/i
    end
    
    describe 'getting a rank' do
      before do
        client1.provide_input('Ace')
        lobby.run_round
      end

      it 'gets a card rank request from the current player' do
        expect(client1.capture_output).to match /You requested: Ace/i
        lobby.run_round
        expect(client1.capture_output).to_not match /You requested:/i
      end
    end
    
    describe 'getting an opponent' do
      before do
        client1.provide_input('Ace')
        lobby.run_round
        client1.provide_input('Player 2')
        lobby.run_round
      end

      it 'displays the opponents once' do
        expect(client1.capture_output).to match /opponents:/i
        lobby.run_round
        expect(client1.capture_output).to_not match /opponents:/i
      end
    
      it 'requests a target player from the current player once' do
        expect(client1.capture_output).to match /Which opponent would you like to request from:/i
        lobby.run_round
        expect(client1.capture_output).to_not match /Which opponent would you like to request from:/i
      end
    end

    describe 'play round' do
      let(:ace_hearts) { PlayingCard.new('Ace', 'Hearts') }
      let(:ace_clubs) { PlayingCard.new('Ace', 'Clubs') }
      let(:king_hearts) { PlayingCard.new('King', 'Hearts') }
      let(:king_clubs) { PlayingCard.new('King', 'Clubs') }

      before do
        player1.hand = [ace_hearts, king_hearts]
        player2.hand = [ace_clubs, king_clubs]
        client1.provide_input('Ace')
        lobby.run_round
        client1.provide_input('Player 2')
        lobby.run_round
      end
      it 'when player 1 gets a card from player 2' do
        expect(player1.hand).to include(ace_hearts, king_hearts, ace_clubs)
        expect(player2.hand).to include(king_clubs)
      end
    end

    describe 'displaying results' do
      context 'when player has input rank and opponent' do
        before do
          client1.provide_input('Ace')
          lobby.run_round
          client1.provide_input('Player 2')
          lobby.run_round
        end

        xit 'displays round results to players' do
          expect(client1.capture_output).to include('Player 1', 'Player 2', 'Ace')
        end
      end

      context 'when player has input rank but not opponent' do
        before do
          client1.provide_input('Ace')
          lobby.run_round
        end

        xit 'displays round results to players' do
          expect(client1.capture_output).to_not include('Player 1', 'Player 2', 'Ace')
        end
      end

      context 'when player has not input anything' do
        before do
          lobby.run_round 
        end
        
        xit 'displays round results to players' do
          expect(client1.capture_output).to_not include('Player 1', 'Player 2', 'Ace')
        end
      end
    end
  end

  # want a red test that fails because I don't have the right result
  # rank requested and player requested, was it a go_fish or was it found in the players hand
  # hand size changed

  private

  def setup_game_with_players
    @clients.push(client1)
    @server.accept_new_client('Player 1')

    @clients.push(client2)
    @server.accept_new_client('Player 2')
    @server.create_game_if_possible
  end
end
