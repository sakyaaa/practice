# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/king'

RSpec.describe 'Chess Pieces' do
  let(:board) { Board.new }

  describe Pawn do
    let(:white_pawn) { board[[6, 0]] }
    let(:black_pawn) { board[[1, 0]] }

    it 'can move forward one square' do
      expect(white_pawn.moves(board)).to include([5, 0])
      expect(black_pawn.moves(board)).to include([2, 0])
    end

    it 'can move forward two squares from starting position' do
      expect(white_pawn.moves(board)).to include([4, 0])
      expect(black_pawn.moves(board)).to include([3, 0])
    end

    it 'cannot move forward if blocked' do
      board[[5, 0]] = Pawn.new(:black, [5, 0])
      expect(white_pawn.moves(board)).not_to include([5, 0], [4, 0])
    end

    it 'can capture diagonally' do
      board[[5, 1]] = Pawn.new(:black, [5, 1])
      expect(white_pawn.moves(board)).to include([5, 1])
    end
  end

  describe Rook do
    let(:white_rook) { board[[7, 0]] }

    it 'can move horizontally and vertically' do
      board[[6, 0]] = nil
      board[[7, 1]] = nil

      expect(white_rook.moves(board)).to include([6, 0], [7, 1])
    end

    it 'cannot move through other pieces' do
      expect(white_rook.moves(board)).not_to include([5, 0])
    end

    it 'can capture enemy pieces' do
      board[[6, 0]] = Pawn.new(:black, [6, 0])
      expect(white_rook.moves(board)).to include([6, 0])
    end
  end

  describe Knight do
    let(:white_knight) { board[[7, 1]] }

    it 'moves in L-shape pattern' do
      expect(white_knight.moves(board)).to include([5, 0], [5, 2])
    end

    it 'can jump over other pieces' do
      board[[6, 0]] = Pawn.new(:white, [6, 0])
      board[[6, 1]] = Pawn.new(:white, [6, 1])
      expect(white_knight.moves(board)).to include([5, 0], [5, 2])
    end

    it 'cannot capture friendly pieces' do
      board[[5, 0]] = Pawn.new(:white, [5, 0])
      expect(white_knight.moves(board)).not_to include([5, 0])
    end
  end

  describe Bishop do
    let(:white_bishop) { board[[7, 2]] }

    it 'can move diagonally' do
      board[[6, 1]] = nil
      board[[6, 3]] = nil

      expect(white_bishop.moves(board)).to include([6, 1], [6, 3])
    end

    it 'cannot move through other pieces' do
      expect(white_bishop.moves(board)).not_to include([5, 0])
    end

    it 'can capture enemy pieces' do
      board[[6, 1]] = Pawn.new(:black, [6, 1])
      expect(white_bishop.moves(board)).to include([6, 1])
    end
  end

  describe Queen do
    let(:white_queen) { board[[7, 3]] }

    it 'can move horizontally, vertically, and diagonally' do
      board[[6, 2]] = nil
      board[[6, 3]] = nil
      board[[6, 4]] = nil

      expect(white_queen.moves(board)).to include([6, 2], [6, 3], [6, 4])
    end

    it 'cannot move through other pieces' do
      expect(white_queen.moves(board)).not_to include([5, 3])
    end

    it 'can capture enemy pieces' do
      board[[6, 3]] = Pawn.new(:black, [6, 3])
      expect(white_queen.moves(board)).to include([6, 3])
    end
  end

  describe King do
    let(:white_king) { board[[7, 4]] }

    it 'can move one square in any direction' do
      board[[6, 3]] = nil
      board[[6, 4]] = nil
      board[[6, 5]] = nil

      expect(white_king.moves(board)).to include([6, 3], [6, 4], [6, 5])
    end

    it 'cannot move into check' do
      board[[6, 4]] = nil
      board[[5, 4]] = Queen.new(:black, [5, 4])
      expect(white_king.moves(board)).not_to include([6, 4])
    end

    it 'can capture enemy pieces' do
      board[[6, 4]] = Pawn.new(:black, [6, 4])
      expect(white_king.moves(board)).to include([6, 4])
    end
  end
end
