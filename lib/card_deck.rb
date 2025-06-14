require_relative 'playing_card'

class CardDeck
  attr_accessor :cards
  DECK_COUNT = 52 
  def initialize
    @cards = build_deck
  end

  def build_deck
    PlayingCard::RANKS.map do |rank|
      PlayingCard::SUITS.map do |suit|
        PlayingCard.new(rank, suit)
      end
    end.flatten
  end
  
  def deal_card
    cards.pop
  end

  def add_cards(added_cards)
    return cards << added_cards if added_cards.is_a?(PlayingCard)
    added_cards.each { |card| cards << card }
  end
end