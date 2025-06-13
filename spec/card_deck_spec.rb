require 'spec_helper'
require_relative '../lib/card_deck'

RSpec.describe CardDeck do
  let(:deck) { CardDeck.new }
  it 'has a specified deck length' do
    expect(deck.cards.length).to eq CardDeck::DECK_SIZE
  end
  it 'holds playing cards' do
    expect(deck.cards.first).to be_a(PlayingCard)
  end
  it 'deals a card' do
    expect(deck.deal_card).to be_a(PlayingCard)
  end
end