require_relative 'result'
require_relative 'card_deck'

class GoFishGame
  attr_reader :players
  attr_accessor :current_player, :opponent, :deck

  def initialize(players, deck = CardDeck.new)
    @players = players
    @current_player = players.first
    @opponent = players.last
    @deck = deck
  end

  def start
    deal_cards
  end

  def play_round(rank, opponent)
    taken_cards = take_cards(rank, opponent)
    unless taken_cards
      fished_card = go_fish
    end
    result(fished_card: fished_card, taken_cards: taken_cards, rank: rank)
  end
  
  def deal_card
    deck.deal_card
  end
  
  def result(fished_card:, taken_cards:, rank:)
    Result.new(current_player:, opponent:, rank:, taken_cards:, fished_card:)
  end
  private
  
  def deal_cards
    if players.length > 3
      Player::SMALL_HAND_SIZE.times do
        players.each do |player|
          player.add_cards(deal_card)
        end
      end
    else
      Player::BASE_HAND_SIZE.times do
        players.each do |player|
          player.add_cards(deal_card)
        end
      end
    end
  end
  
  def go_fish
    dealt_card = deal_card
    current_player.add_cards(dealt_card)
    dealt_card
  end
  
  def take_cards(rank, opponent)
    cards = opponent.hand.select { |card| card.rank == rank }
    unless cards.empty?
      opponent.remove_cards(cards)
      return current_player.add_cards(cards)
    end
    nil
  end
end