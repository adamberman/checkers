# encoding: UTF-8

require './piece.rb'
require 'colorize'
require 'byebug'

class Board

	attr_accessor :grid

	def initialize(populate = true)
		@grid = Array.new(8) { Array.new(8) }
		populate_board if populate
	end

	def self.in_bounds?(pos)
		pos.all? { |x| x.between?(0, 7) }
	end

	def populate_board
		(0..7).each do |j|
			(0..3).each do |i|
				next if j == 3 || j == 4
				set_piece(i, j)
			end
		end
	end

	def set_piece(x, y)
		offset = y % 2 == 0 ? 0 : 1
		color = y >= 5 ? :b : :w
		pos = [(x * 2) + offset, y]
		self[pos] = Piece.new(color, self, pos)
	end

	def [](pos)
		x, y = pos
		@grid[y][x]
	end

	def []=(pos, piece)
		x, y = pos
		@grid[y][x] = piece
	end

	def dup
		board_dup = Board.new(false)
		@grid.each do |row|
			row.each do |col|
				next if col.nil?
				board_dup[col.pos] = Piece.new(col.color, board_dup, col.pos, col.king)
			end
		end

		board_dup
	end

	def won?(color)
		check_color = recolor[color]
		squares.none? { |piece| piece.color == check_color }
	end

	def draw?
		one_white? && one_black?
	end

	def one_white?
		squares.one? { |piece| piece.color == :w }
	end

	def one_black?
		squares.one? { |piece| piece.color == :b }
	end

	def squares
		grid.flatten.compact
	end

	def colored_pieces(color)
		squares.select { |piece| piece.color == color}
	end

	def display
		display_letters
		display_grid
		display_letters
	end

	def display_letters
		print "  "
		('a'..'h').each { |letter| print " #{letter} " } 
		puts "\n"
	end

	def display_grid
		color = :light_white
		grid.each_with_index do |row, i|
			print "#{i + 1} "
			color = recolor[color]
			row.each do |square|
				color = recolor[color]
				display_square(row, square, color)
			end
			puts " #{i + 1} "
		end
	end

	def display_square(row, square, color)
		if square.nil?
			print "   ".colorize(:background => color) 
		else
			print square.inspect.colorize(:background => color)
		end
	end

	def recolor
		{ :light_white => :light_black,
			:light_black => :light_white,
			:w => :b,
			:b => :w
		}
	end
end

# board = Board.new(false)
# piece1 = Piece.new(:b, board, [2,4])
# piece2 = Piece.new(:w, board, [3,3])
# piece3 = Piece.new(:w, board, [5,1])
# board[[2,4]] = piece1
# board[[3,3]] = piece2
# board[[5,1]] = piece3
# p piece1.perform_moves([[4,2], [6,0]])
# p board[[2,4]]
# p board[[1,3]]
# p board[[3,3]]
# p board[[4,2]]
# p board[[5,1]]
# p board[[6,0]]

