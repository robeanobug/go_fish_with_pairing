require_relative '../lib/player'
require 'spec_helper'

RSpec.describe Player do
  let(:player) { Player.new('Player 1') }
  let(:ace_clubs) {PlayingCard.new('Ace', 'Clubs') }
  let(:ace_hearts) {PlayingCard.new('Ace', 'Hearts') }
  it 'has a name' do
    expect(player.name).to eq('Player 1')
  end
  it 'has a hand' do
    expect(player.hand).to be_a(Array)
  end
  it 'adds cards to the hand' do
    player.add_cards([ace_clubs, ace_hearts])
    expect(player.hand).to eq([ace_clubs, ace_hearts])
  end
  it 'removes cards from hand' do
    player.hand = [ace_clubs, ace_hearts]
    player.remove_cards([ace_clubs, ace_hearts])
    expect(player.hand).to eq([])
  end
end