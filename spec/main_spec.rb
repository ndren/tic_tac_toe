# frozen_string_literal: true

require './lib/main'
describe Board do
  describe '#to_s' do
    subject(:board) { described_class.new }
    it 'returns the board' do
      expected_layout = "   \n   \n   "
      actual_layout = board.to_s
      expect(actual_layout).to eql(expected_layout)
    end
  end
end
describe Game do
  subject(:game) { described_class.new }
  let(:transparent_board) { [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '] }
  describe '#end_turn' do
    it 'returns O on first call' do
      starting_player = game.instance_variable_get(:@player)
      game.end_turn
      next_player = game.instance_variable_get(:@player)
      expect([starting_player, next_player]).to eql(%w[X O])
    end
  end
  describe '#move!' do
    it 'does not work with a symbol' do
      expect(game).to receive(:puts).with('Invalid input.')
      game.move!('$', transparent_board)
    end
    it 'does not work when index is outside the set (0, 9)' do
      expect(game).to receive(:puts).with('Area is outside the board.')
      game.move!('10', transparent_board)
    end
    it 'changes the index one lower' do
      game.move!('5', transparent_board)
      changed = transparent_board[4]
      expect(changed).to eql('X')
    end
    it 'does not change used indices' do
      expect(game).to receive(:puts).with('Area is used by another player.')
      game.move!('6', transparent_board)
      game.move!('6', transparent_board)
    end
  end
  describe '#all_equal?' do
    it 'returns true for the starting board' do
      check_first_column = game.all_equal?([0, 1, 2], transparent_board)
      expect(check_first_column).to eql(true)
    end
    it 'returns false when cells are different' do
      transparent_board[4] = 'X'
      check_diagonal = game.all_equal?([0, 4, 8], transparent_board)
      expect(check_diagonal).to eql(false)
    end
    it 'returns true when all cells are the same and not empty' do
      x_cells = [0, 1, 2]
      for i in (x_cells) do
        transparent_board[i] = 'X'
      end
      check_across = game.all_equal?(x_cells, transparent_board)
      expect(check_across).to eql(true) 
    end
  end
end
