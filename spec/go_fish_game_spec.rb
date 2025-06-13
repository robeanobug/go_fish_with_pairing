require_relative '../lib/go_fish_game'
require_relative '../lib/player'

RSpec.describe GoFishGame do
  let(:player1) { Player.new('Player 1') }
  let(:player2) { Player.new('Player 2') }
  let(:player3) { Player.new('Player 3') }
  let(:player4) { Player.new('Player 4') }

  let(:game) { GoFishGame.new([player1, player2]) }
  let(:game_with_four_players) { GoFishGame.new([player1, player2, player3, player4]) }


  context '#initialize' do
    it 'initializes game with players' do
      expect(game.players.first).to be_a(Player)
    end

    it 'has a current_player' do
      expect(game.current_player).to be_a(Player)
    end
    
    it 'has an opponent' do
      expect(game.opponent).to be_a(Player)
    end

    it 'has a round result' do
      expect(game.result).to be_a(Result)
    end
  end

  describe '#deal_card' do
    it 'should deal a card from the deck' do
      expect(game.deal_card).to be_a(PlayingCard)
    end
  end

  describe '#start' do
    it 'should deal out the base hand size to 2 players' do
      game.start
      expect(game.current_player.hand.size).to eq(Player::BASE_HAND_SIZE)
    end
    it 'should deal out the small hand size to 4 players' do
      game_with_four_players.start
      expect(game_with_four_players.current_player.hand.size).to eq(Player::SMALL_HAND_SIZE)
    end
  end

  describe '#play_round' do
  let(:ace_hearts) { PlayingCard.new('Ace', 'Hearts') }
  let(:king_hearts) { PlayingCard.new('King', 'Hearts') }
  let(:ace_clubs) { PlayingCard.new('Ace', 'Clubs') }
  let(:king_clubs) { PlayingCard.new('King', 'Clubs')}
  let(:ace_diamonds) { PlayingCard.new('Ace', 'Diamonds') }
  let(:ace_spades) { PlayingCard.new('Ace', 'Spades') }
  let(:two_hearts) { PlayingCard.new('2', 'Hearts') }

    context "When the current player's turn stays" do
      it 'current player gets cards from opponent' do
        player1.hand = [ace_hearts, king_hearts]
        player2.hand = [ace_clubs, king_clubs]
        game.play_round('Ace', player2)

        expect(player1.hand).to include(ace_hearts, king_hearts, ace_clubs)
        expect(player2.hand).to include(king_clubs)
      end
      it 'current player gets cards from opponent and creates a book' do
        player1.hand = [ace_hearts, king_hearts]
        player2.hand = [ace_clubs, ace_spades, ace_diamonds, king_clubs]
        game.play_round('Ace', player2)

        expect(player1.hand).to include(king_hearts)
        expect(player2.hand).to include(king_clubs)
      end

      it 'current player goes fishing and catches the requested card' do
        game.deck.cards.push(ace_clubs)
        player1.hand = [ace_hearts, king_hearts]
        player2.hand = [king_clubs]
        game.play_round('Ace', player2)

        expect(player1.hand).to include(ace_hearts, king_hearts, ace_clubs)
        expect(player2.hand).to include(king_clubs)
      end
    end
    context "When the current player's turn changes" do
      it 'current player goes fishing and does not catch the requested card' do
        game.deck.cards.push(two_hearts)
        player1.hand = [ace_hearts, king_hearts]
        player2.hand = [king_clubs]
        game.play_round('Ace', player2)

        expect(player1.hand).to eq([ace_hearts, king_hearts, two_hearts])
        expect(player2.hand).to eq([king_clubs])
      end
    end
  end
end