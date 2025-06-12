require_relative '../lib/go_fish_game'
require_relative '../lib/player'

RSpec.describe GoFishGame do
  let(:player1) { Player.new('Player 1') }
  let(:player2) { Player.new('Player 2') }
  let(:game) { GoFishGame.new([player1, player2]) }

  it 'initializes game with players' do
    expect(game.players.first).to be_a(Player)
  end

  it 'has a current_player' do
    expect(game.current_player).to be_a(Player)
  end
  
  it 'has an opponent' do
    expect(game.opponent).to be_a(Player)
  end

  it 'has a round result' do
    expect(game.result).to be_a(Result)
  end
end