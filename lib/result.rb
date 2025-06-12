class Result
  attr_reader :current_player, :opponent, :fished_card, :cards_received

  def initialize(current_player, opponent, fished_card = nil, cards_recieved = nil)
    @current_player = current_player
    @opponent = opponent
    @fished_card = fished_card
    @cards_recieved = cards_recieved
  end

  def current_player_result
    # "You took #{cards_recieved.map { |card| "#{card.rank} of #{card.suit }" } } from #{ opponent.name }"
    "You took a card"
  end

  def opponent_result
    "A card was taken from you"
  end

  def bystanders_result
    "Current player took a card from opponent"
  end
end