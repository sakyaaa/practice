# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/king'

RSpec.describe Game do
  let(:game) { Game.new }
  let(:board) { game.board }

  describe '#initialize' do
    it 'creates a new game with a board and two players' do
      expect(game.board).to be_a(Board)
      expect(game.players.length).to eq(2)
      expect(game.current_player).to eq(game.players[0])
    end
  end

  describe '#valid_move?' do
    it 'validates legal pawn moves' do
      expect(game.valid_move?('e2 e4')).to be true
      expect(game.valid_move?('e2 e5')).to be false
    end

    it 'validates legal knight moves' do
      expect(game.valid_move?('b1 c3')).to be true
      expect(game.valid_move?('b1 c4')).to be false
    end
  end

  describe '#in_check?' do
    it 'detects when a king is in check' do
      board[[7, 4]] = nil
      board[[6, 4]] = King.new(:white, [6, 4])
      board[[5, 3]] = Queen.new(:black, [5, 3])

      expect(board.in_check?(:white)).to be true
    end
  end
end
