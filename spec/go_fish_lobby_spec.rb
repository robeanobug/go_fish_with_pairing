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
      context 'when a rank is valid' do
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
      context 'when a rank is invalid' do
        before do
          client1.provide_input('foo')
          lobby.run_round
        end
        it 'gets a card rank request from the current player' do
          expect(client1.capture_output).to match /Please request a card rank/i
          client1.provide_input('Ace')
          lobby.run_round
          expect(client1.capture_output).to match /You requested: Ace/i
        end
      end
    end
    
    describe 'getting an opponent' do
      before do
        client1.provide_input('Ace')
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

      context 'when turn stays the same' do
        context 'When player 1 gets a card from player 2' do
          before do
            player1.hand = [ace_hearts, king_hearts]
            player2.hand = [ace_clubs, king_clubs]
            client1.provide_input('Ace')
            lobby.run_round
            client1.provide_input('Player 2')
            lobby.run_round
          end
          # only test ouputs in the lobby, the actual card output should be in the game
          xit 'Player 1 should have all the cards of the asked rank from Player 2' do
            expect(player1.hand).to include(ace_hearts, king_hearts, ace_clubs)
            expect(player2.hand).to include(king_clubs)
          end
          xit 'Player 1 goes fish and catches the requested card, Player 2 has original cards' do
            # need to set up deck so player will go fish and get the card they want
            hand_length = 3
            expect(player1.hand).to include(ace_hearts, king_hearts)
            expect(player1.hand.length).to eq hand_length
            expect(player2.hand).to include(king_clubs)
          end
        end
        context 'When turns changes' do
          before do
            lobby.game.deck.cards.push(Playing.card.new('2', 'Spades'))
            player1.hand = [ace_hearts, king_hearts]
            player2.hand = [king_clubs]
            client1.provide_input('Ace')
            lobby.run_round
            client1.provide_input('Player 2')
            lobby.run_round
          end
          xit 'Player 1 tries to go fish for a card but does not collect it' do
            expect(client1.capture_output).to match /turn is over/i
          end
        end
      end

      context 'when player 1 has to go fish' do
        let(:ace_hearts) { PlayingCard.new('Ace', 'Hearts') }
        let(:ace_clubs) { PlayingCard.new('Ace', 'Clubs') }
        let(:king_hearts) { PlayingCard.new('King', 'Hearts') }
        let(:king_clubs) { PlayingCard.new('King', 'Clubs') }

        before do
          player1.hand = [ace_hearts, king_hearts]
          player2.hand = [king_clubs]
          client1.provide_input('Ace')
          lobby.run_round
          client1.provide_input('Player 2')
          lobby.run_round
        end
      end
    end

    describe 'displaying results' do
      context 'when player has input rank and opponent' do
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
        it 'displays round results to players once' do
          expect(client1.capture_output).to include('You', 'took', 'Ace', 'Player 2')
          # You took: Ace of Clubs
          # From: Player 2
          lobby.run_round
          expect(client1.capture_output).to_not match /result/
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

  private

  def setup_game_with_players
    @clients.push(client1)
    client1.provide_input('Player 1')
    @server.accept_new_client
    @server.get_player_name

    @clients.push(client2)
    client2.provide_input('Player 2')
    @server.accept_new_client
    @server.get_player_name

    @server.create_game_if_possible
  end
end
