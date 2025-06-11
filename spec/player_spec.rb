require_relative '../lib/player'
require 'spec_helper'

RSpec.describe Player do
  it 'has a name' do
    expect(Player.new('Player 1').name).to eq('Player 1')
  end
end