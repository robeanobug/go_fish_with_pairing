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

  def play_round
    result
  end
  
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

  def deal_card
    deck.deal_card
  end

  def result
    Result.new(current_player, opponent, 'cards_recieved', 'fished_card')
  end
end