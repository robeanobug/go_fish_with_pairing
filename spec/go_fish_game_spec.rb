require_relative '../lib/go_fish_game'
require_relative '../lib/player'

describe GoFishGame do

  it 'initializes game with players' do
    player1 = Player.new('Player 1')
    player2 = Player.new('Player 2')
    game = GoFishGame.new([player1, player2])

    expect(game.players.first).to be_a(Player)
  end
end