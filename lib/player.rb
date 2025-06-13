class Player
  attr_reader :name
  attr_accessor :hand
  def initialize(name)
    @name = name
    @hand = []
  end

  def add_cards(cards)
    cards.each { |card| hand << card}
  end

  def remove_cards(cards)
    self.hand -= cards
  end
end