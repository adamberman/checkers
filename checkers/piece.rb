# encoding: UTF-8

class InvalidMoveError < ArgumentError
end

class Piece

	DIRECTIONS = [[1, 1], [-1, 1], [1, -1], [-1, -1]]

	attr_accessor :king, :pos

	attr_reader :color, :board

	def initialize(color, board, pos, king = false)
		@color, @board, @pos = color, board, pos
		@king = king
	end

  def perform_moves(move_sequence)
    raise InvalidMoveError unless valid_move_seq?(move_sequence)
    perform_moves!(move_sequence)
    maybe_promote?
  end

  def inspect
    if king
      color == :b ? ' ■ ' : ' □ '
    else  
      color == :b ? ' ● ' : ' ◯ '
    end
  end

  def can_move?
  end

protected 
  def perform_moves!(move_sequence)
    #errors: more than 2 slides, slide to invalid place, jump to invalid place
    move_sequence.each do |move|
      if is_a_slide?(move) && move_sequence.count == 1
        raise InvalidMoveError unless perform_slide(move)
      elsif is_a_slide?(move)
        raise InvalidMoveError
      else
        raise InvalidMoveError unless perform_jump(move)
      end
    end
  end

  def valid_move_seq?(move_sequence)
    piece_dup = dup
    begin
      piece_dup.perform_moves!(move_sequence)
    rescue InvalidMoveError
      return false
    else
      true
    end
  end

  def dup
    Piece.new(color, board.dup, pos, king)
  end

  def is_a_slide?(end_pos)
    return true if (end_pos[0] - pos[0]).abs == 1
    false
  end

  def perform_slide(end_pos)
    if board.class.in_bounds?(end_pos) && slideable?(end_pos)
      move(end_pos)
      return true
    end

    false
  end

  def perform_jump(end_pos)
    if board.class.in_bounds?(end_pos) && jumpable?(end_pos)
      jump(end_pos)
      return true
    end

    false
  end

	def slideable?(end_pos)
		board[end_pos].nil? && in_valid_direction?(end_pos, 1)
	end

	def in_valid_direction?(end_pos, spaces)
		move_directions.each do |direction|
			x = pos[0] + (spaces * direction[0])
			y = pos[1] + (spaces * direction[1])
			return true if [x, y] == end_pos
		end

		false
	end

  def move(end_pos)
    board[pos] = nil
    self.pos = end_pos
    board[pos] = self
  end

  def jump(end_pos)
    board[jumped_space_coords(end_pos)] = nil
    move(end_pos)
  end

	def jumpable?(end_pos)
		jumping_space?(end_pos) && in_valid_direction?(end_pos, 2)
	end

	def jumping_space?(end_pos)
		board[end_pos].nil? && something_to_jump?(end_pos)
	end

  def jumped_space_coords(end_pos)
    x = pos[0] + ((end_pos[0] - pos[0]) / 2)
    y = pos[1] + ((end_pos[1] - pos[1]) / 2)
    [x, y]
  end

	def something_to_jump?(end_pos)
    jumped_coords = jumped_space_coords(end_pos)
		!board[jumped_coords].nil? && board[jumped_coords].color != color
	end

	def move_directions
		return DIRECTIONS if king
		return DIRECTIONS[0..1] if color == :w
		DIRECTIONS[2..3]
	end

	def maybe_promote?
    reached_last_row = color == :b ? pos[1] == 0 : pos[1] == 7
		if reached_last_row
      self.king = true
    end
	end
end