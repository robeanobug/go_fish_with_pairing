require 'spec_helper'
require_relative '../lib/card_deck'

RSpec.describe CardDeck do
  let(:deck) { CardDeck.new }
  it 'has a specified deck length' do
    expect(deck.cards.length).to eq CardDeck::DECK_COUNT
  end
  it 'holds playing cards' do
    expect(deck.cards.first).to be_a(PlayingCard)
  end
  it 'deals a card' do
    expect(deck.deal_card).to be_a(PlayingCard)
  end
  it 'adds a card' do
    three_diamonds = PlayingCard.new('3', 'Diamonds')
    deck.add_cards(three_diamonds)
    expect(deck.deal_card).to eq(three_diamonds)
  end
  it 'adds cards' do
    three_diamonds = PlayingCard.new('3', 'Diamonds')
    four_clubs = PlayingCard.new('4', 'Clubs')
    deck.add_cards([three_diamonds, four_clubs])

    expect(deck.deal_card).to eq(four_clubs)
    expect(deck.deal_card).to eq(three_diamonds)
  end

end