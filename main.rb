# frozen_string_literal: true

class Board
  attr_accessor :board

  def initialize
    @board = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
  end

  def to_s
    "#{@board[0] + @board[1] + @board[2]}
#{@board[3] + @board[4] + @board[5]}
#{@board[6] + @board[7] + @board[8]}"
  end
end

class Game
  attr_reader :player

  def initialize
    @player = 'X'
  end

  def end_turn
    case @player
    when 'O'
      @player = 'X'
    when 'X'
      @player = 'O'
    end
  end

  def move!(index, board)
    if index.to_i.to_s != index
      puts 'Invalid input.'
    elsif (index.to_i > 9) || (index.to_i < 1)
      puts 'Area is outside the board.'
    elsif board[index.to_i - 1] == ' '
      board[index.to_i - 1] = @player
      end_turn
    else
      puts 'Area is used by another player.'
    end
  end

  def all_equal?(indices, board)
    list = []
    indices.each do |i|
      list.append(board[i])
    end
    list.all? { |x| x == list.first }
  end

  def who_won?(indices, board)
    if !all_equal?(indices, board)
      nil
    elsif board[indices[0]] == 'X'
      'X'
    elsif board[indices[0]] == 'O'
      'O'
    elsif board[indices[0]] == ' '
      nil
    end
  end

  def check_endgame(board)
    draw = false
    x_won = false
    o_won = false

    rows = [[0, 1, 2], [3, 4, 5], [7, 8, 9]]
    columns = [[0, 3, 6], [1, 4, 7], [2, 5, 8]]
    diagonals = [[0, 4, 8], [2, 4, 6]]
    zones_to_check = rows + columns + diagonals

    zones_to_check.each do |zone|
      result = who_won?(zone, board)
      case result
      when 'X'
        x_won = true
      when 'O'
        o_won = true
      end
    end

    all_filled = true
    9.times do |i|
      all_filled = false if board[i] == ' '
    end
    draw = true if all_filled

    if x_won
      'X'
    elsif o_won
      'O'
    elsif draw
      'draw'
    else
      'TBD'
    end
  end
end

board = Board.new
game = Game.new

puts 'Welcome to Tic Tac Toe! (Or Noughts and Crosses, the world cannot decide.)'
puts 'The board is layed out in this format:'
puts '123'
puts '456'
puts '789'
puts 'Good luck!'
puts

while game.check_endgame(board.board) == 'TBD'
  puts "It is #{game.player}'s turn. Make your move."
  game.move!(gets.chomp, board.board)
  puts board.to_s
end

case game.check_endgame(board.board)
when 'X'
  puts 'X wins!'
when 'O'
  puts 'O wins!'
when 'draw'
  puts 'It\'s a draw!'
end
