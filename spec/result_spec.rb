require 'spec_helper'
require_relative '../lib/result'
require_relative '../lib/player'

RSpec.describe Result do
  let(:result) { Result.new('Player 1', 'Player 2', ['Ace of Clubs'] )}
  it 'has a current player result' do
    expect(result.current_player_result).to match /You took a card/i
  end

  it 'has an opponent result' do
    expect(result.opponent_result).to match /card was taken/i
  end

  it 'has a result for bystanders' do
    expect(result.bystanders_result).to match /took a card/i
  end
end
