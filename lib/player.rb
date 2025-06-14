class Player
  attr_reader :name
  attr_accessor :hand
  BASE_HAND_SIZE = 7
  SMALL_HAND_SIZE = 5
  def initialize(name)
    @name = name
    @hand = []
  end

  def add_cards(cards)
    return hand << cards if cards.is_a?(PlayingCard)
    cards.each { |card| hand << card }
  end

  def remove_cards(cards)
    self.hand -= cards
  end
end