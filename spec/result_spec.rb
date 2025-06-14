require 'spec_helper'
require_relative '../lib/result'
require_relative '../lib/player'
require_relative '../lib/playing_card'

RSpec.describe Result do
  let(:player1) { Player.new('Player 1') }
  let(:player2) { Player.new('Player 2') }
  let(:player3) { Player.new('Player 3') }
  let(:taken_cards) { [PlayingCard.new('Ace', 'Clubs'), PlayingCard.new('Ace', 'Spades')]}
  let(:fished_ace) { PlayingCard.new('Ace', 'Clubs') }
  let(:fished_two) { PlayingCard.new('2', 'Clubs') }
  let(:result) { Result.new(current_player: player1, opponent: player2, rank: 'Ace', taken_cards: ) }

  context 'when current player takes a card from opponent' do
    
    it 'has a current player result' do
      expect(result.current_player_result).to match /You took/i
    end
    xit 'has an opponent result' do
      expect(result.opponent_result).to match /was taken/i
    end
    xit 'has a result for bystanders' do
      expect(result.bystanders_result).to include('took', 'from')
    end
  end
end
