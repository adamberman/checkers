
class Player

	attr_reader :color, :board

	def initialize(color, board)
		@color, @board = color, board
	end

	def take_turn
		raise "Error, should not be instantiating Player class"
	end
end