# frozen_string_literal: true

require_relative '../lib/connect_four'

RSpec.describe ConnectFour do
  subject(:game) { ConnectFour.new }

  describe '#initialize' do
    it 'creates a new game with an empty board' do
      expect(game.board).to eq(Array.new(6) { Array.new(7, nil) })
    end
  end

  describe '#drop_piece' do
    it 'places a piece in the specified column' do
      game.drop_piece(0, '🔴')
      expect(game.board[5][0]).to eq('🔴')
    end

    it 'stacks pieces on top of each other' do
      game.drop_piece(0, '🔴')
      game.drop_piece(0, '🔵')
      expect(game.board[4][0]).to eq('🔵')
    end

    it 'raises an error when column is full' do
      6.times { game.drop_piece(0, '🔴') }
      expect { game.drop_piece(0, '🔵') }.to raise_error(ArgumentError, 'Column is full')
    end
  end

  describe '#valid_move?' do
    it 'returns true for valid column numbers' do
      expect(game.valid_move?(0)).to be true
      expect(game.valid_move?(6)).to be true
    end

    it 'returns false for invalid column numbers' do
      expect(game.valid_move?(-1)).to be false
      expect(game.valid_move?(7)).to be false
    end

    it 'returns false for full columns' do
      6.times { game.drop_piece(0, '🔴') }
      expect(game.valid_move?(0)).to be false
    end
  end

  describe '#winner?' do
    it 'returns true for horizontal win' do
      4.times { |i| game.drop_piece(i, '🔴') }
      expect(game.winner?).to be true
    end

    it 'returns true for vertical win' do
      4.times { game.drop_piece(0, '🔴') }
      expect(game.winner?).to be true
    end

    it 'returns true for diagonal win (up-right)' do
      game.drop_piece(0, '🔴')
      game.drop_piece(1, '🔵')
      game.drop_piece(1, '🔴')
      game.drop_piece(2, '🔵')
      game.drop_piece(2, '🔵')
      game.drop_piece(2, '🔴')
      game.drop_piece(3, '🔵')
      game.drop_piece(3, '🔵')
      game.drop_piece(3, '🔵')
      game.drop_piece(3, '🔴')
      expect(game.winner?).to be true
    end

    it 'returns true for diagonal win (up-left)' do
      game.drop_piece(3, '🔴')
      game.drop_piece(2, '🔵')
      game.drop_piece(2, '🔴')
      game.drop_piece(1, '🔵')
      game.drop_piece(1, '🔵')
      game.drop_piece(1, '🔴')
      game.drop_piece(0, '🔵')
      game.drop_piece(0, '🔵')
      game.drop_piece(0, '🔵')
      game.drop_piece(0, '🔴')
      expect(game.winner?).to be true
    end

    it 'returns false when there is no winner' do
      game.drop_piece(0, '🔴')
      game.drop_piece(1, '🔵')
      expect(game.winner?).to be false
    end
  end

  describe '#draw?' do
    it 'returns false when board is empty' do
      expect(game.draw?).to be false
    end

    it 'returns false when board is partially filled' do
      3.times { |i| game.drop_piece(i, '🔴') }
      expect(game.draw?).to be false
    end

    it 'returns true when board is full' do
      pattern = [
        ['🔴', '🔵', '🔵', '🔵', '🔴', '🔴', '🔴'],
        ['🔵', '🔴', '🔴', '🔴', '🔵', '🔵', '🔵'],
        ['🔴', '🔵', '🔵', '🔵', '🔴', '🔴', '🔴'],
        ['🔵', '🔴', '🔴', '🔴', '🔵', '🔵', '🔵'],
        ['🔴', '🔵', '🔵', '🔵', '🔴', '🔴', '🔴'],
        ['🔵', '🔴', '🔴', '🔴', '🔵', '🔵', '🔵']
      ]

      6.times do |row|
        7.times do |col|
          game.drop_piece(col, pattern[row][col])
        end
      end
      expect(game.draw?).to be true
    end

    it 'returns false when there is a winner' do
      4.times { |i| game.drop_piece(i, '🔴') }
      expect(game.draw?).to be false
    end
  end
end
