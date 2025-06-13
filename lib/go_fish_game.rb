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
    go_fish unless take_cards(rank, opponent)
    result
  end
  
  def deal_card
    deck.deal_card
  end
  
  def result
    Result.new(current_player, opponent, 'cards_recieved', 'fished_card')
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
    current_player.add_cards(deal_card)
  end

  def take_cards(rank, opponent)
    cards = opponent.hand.select { |card| card.rank == rank }
    unless cards.empty?
      opponent.remove_cards(cards)
      return current_player.add_cards(cards)
    end
    false
  end
end