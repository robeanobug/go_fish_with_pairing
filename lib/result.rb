class Result
  attr_reader :current_player, :opponent, :fished_card, :taken_cards, :rank

  def initialize(current_player:, opponent:, rank:, taken_cards: nil, fished_card: nil)
    @current_player = current_player
    @opponent = opponent
    @fished_card = fished_card
    @taken_cards = taken_cards
    @rank = rank
  end

  # current_player, target, card_request, matching_cards, fished_card then determine swapped_turns

  # expected to handle all scenarios
  # broadcasting the turn change is not a responsibility of the round result, doesn't know who's next

  def current_player_result
    taken_cards_array = taken_cards&.map { |card| "#{ card.rank } of #{ card.suit }" }
    "You took #{ taken_cards_array } from #{opponent.name}" if taken_cards
  end

  def opponent_result
    # "A card was taken from you"
  end

  def bystanders_result
    # "Current player took a card from opponent"
  end
end