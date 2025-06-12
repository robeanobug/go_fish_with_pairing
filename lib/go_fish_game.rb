require_relative 'result'

class GoFishGame
  attr_reader :players
  attr_accessor :current_player, :opponent
  def initialize(players)
    @players = players
    @current_player = players.first
    @opponent = players.last
  end

  def play_round
    result
  end

  def result
    Result.new('current_player', 'opponent', 'cards_recieved', 'fished_card')
  end
end