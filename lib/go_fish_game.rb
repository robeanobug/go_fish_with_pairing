class GoFishGame
  attr_reader :players
  attr_accessor :current_player
  def initialize(players)
    @players = players
    @current_player = players.first
  end
end