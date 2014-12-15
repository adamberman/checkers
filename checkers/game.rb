require './board.rb'
require './HumanPlayer.rb'
require './ComputerPlayer.rb'

require 'byebug'

class Game

	attr_accessor :current_player

	attr_reader :player1, :player2, :board

	def initialize(player1, player2, board)
		@player1, @player2, @board = player1, player2, board
		@current_player = player1
	end

	def play
		until game_over?
			board.display
			current_player.take_turn
			switch_players
		end
		end_game_message
	end

	def game_over?
		board.draw? || win?
	end

	def win?
		board.won?(:w) || board.won?(:b)
	end

	def switch_players
		self.current_player = ((current_player == player1) ? player2 : player1)
	end

	def end_game_message
		if board.draw?
			puts "It's a draw!"
		else
			puts "Congratulations, #{winner} won the game!"
		end
	end

	def winner
		board.won?(:w) ? "White" : "Black"
	end
end

board = Board.new
game = Game.new(HumanPlayer.new(:w, board), ComputerPlayer.new(:b, board), board)
game.play