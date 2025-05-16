# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/king'

RSpec.describe Board do
  let(:board) { Board.new }

  describe '#initialize' do
    it 'creates an 8x8 grid' do
      expect(board.grid.length).to eq(8)
      expect(board.grid.all? { |row| row.length == 8 }).to be true
    end

    it 'sets up pawns correctly' do
      8.times do |col|
        expect(board[[6, col]]).to be_a(Pawn)
        expect(board[[6, col]].color).to eq(:white)
      end

      8.times do |col|
        expect(board[[1, col]]).to be_a(Pawn)
        expect(board[[1, col]].color).to eq(:black)
      end
    end

    it 'sets up back row pieces correctly' do
      expect(board[[7, 0]]).to be_a(Rook)
      expect(board[[7, 1]]).to be_a(Knight)
      expect(board[[7, 2]]).to be_a(Bishop)
      expect(board[[7, 3]]).to be_a(Queen)
      expect(board[[7, 4]]).to be_a(King)
      expect(board[[7, 5]]).to be_a(Bishop)
      expect(board[[7, 6]]).to be_a(Knight)
      expect(board[[7, 7]]).to be_a(Rook)

      expect(board[[0, 0]]).to be_a(Rook)
      expect(board[[0, 1]]).to be_a(Knight)
      expect(board[[0, 2]]).to be_a(Bishop)
      expect(board[[0, 3]]).to be_a(Queen)
      expect(board[[0, 4]]).to be_a(King)
      expect(board[[0, 5]]).to be_a(Bishop)
      expect(board[[0, 6]]).to be_a(Knight)
      expect(board[[0, 7]]).to be_a(Rook)
    end
  end

  describe '#move_piece' do
    it 'moves a piece from one position to another' do
      piece = board[[6, 0]]
      board.move_piece([6, 0], [5, 0])

      expect(board[[6, 0]]).to be_nil
      expect(board[[5, 0]]).to eq(piece)
      expect(piece.position).to eq([5, 0])
    end
  end

  describe '#in_check?' do
    it 'detects when a king is in check' do
      board[[6, 4]] = nil
      board[[5, 4]] = nil
      board[[4, 4]] = nil

      board.move_piece([0, 3], [4, 4])

      expect(board.in_check?(:white)).to be true
    end

    it 'returns false when king is not in check' do
      expect(board.in_check?(:white)).to be false
      expect(board.in_check?(:black)).to be false
    end
  end

  describe '#checkmate?' do
    it 'detects checkmate' do
      board.move_piece([6, 5], [5, 5])
      board.move_piece([6, 6], [4, 6])
      board.move_piece([1, 4], [3, 4])
      board.move_piece([0, 3], [4, 7])

      expect(board.checkmate?(:white)).to be true
    end

    it 'returns false when not in checkmate' do
      expect(board.checkmate?(:white)).to be false
      expect(board.checkmate?(:black)).to be false
    end
  end

  describe '#stalemate?' do
    it 'detects stalemate' do
      board.grid.each { |row| row.fill(nil) }

      board[[0, 0]] = King.new(:black, [0, 0])
      board[[2, 1]] = King.new(:white, [2, 1])
      board[[1, 2]] = Queen.new(:white, [1, 2])

      expect(board.stalemate?(:black)).to be true
    end

    it 'returns false when not in stalemate' do
      expect(board.stalemate?(:white)).to be false
      expect(board.stalemate?(:black)).to be false
    end
  end
end
