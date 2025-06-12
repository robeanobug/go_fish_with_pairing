require_relative '../lib/player'
require 'spec_helper'

RSpec.describe Player do
  let(:player) { Player.new('Player 1') }
  it 'has a name' do
    expect(player.name).to eq('Player 1')
  end
  it 'has a hand' do
    expect(player.hand).to be_a(Array)
  end
end