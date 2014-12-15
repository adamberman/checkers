require './player.rb'

class ComputerPlayer < Player

	def take_turn
		make_move(sample_piece)
	rescue
		retry
	end

	def make_move(piece)
		slide_locations = PIECE::DIRECTIONS
		jump_locations = slide_locations.map { |pos| [pos[0] * 2, pos[1] * 2]}
		possible_moves = slide_locations + jump_locations
		piece.perform_moves(possible_moves.sample)
	end

	def sample_piece
		board.colored_pieces(color).sample
	end

end