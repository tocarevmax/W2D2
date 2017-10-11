require 'singleton'
# require 'board'
require "byebug"

module SlidingPiece
  DIAGONALLY= [[-1,-1], [-1,1], [1,1], [1,-1]]
  HORIZON_VERT= [[0,1], [0,-1], [1, 0], [-1, 0]]


  # which should return an array of places a Piece can move to
  def moves
    return [] if @position.empty?
    possible_moves = []
    move_dirs.each do |dir| #[-1,-1]
      test_pos = @position  #[1,3] - current position
      valid = true
      while valid
        x = dir.first + test_pos.first
        y = dir.last + test_pos.last
        test_pos = [x,y]
        valid = valid_move?([x,y])
        possible_moves << [x,y] if valid
        valid = false if valid == :attack
      end
    end
    possible_moves
  end

end

module SteppingPiece
  DIAGONALLY= [[-1,-1], [-1,1], [1,1], [1,-1]]
  HORIZON_VERT= [[0,1], [0,-1], [1, 0], [-1, 0]]

  def moves
    return [] if @position.empty?
    possible_moves = []
    move_dirs.each do |dir|
      x = @position.first + dir.first
      y = @position.last + dir.last
      possible_moves << [x,y] if valid_move?([x,y])
    end
    possible_moves
  end
end


class Piece
  DELETED = []
  attr_accessor :board, :position, :color

  def initialize(board, position, color)
    @color = color
    @board = board
    @position = position
  end

  def to_s
    "P"
  end

  def self.all_piece_of(color)
    ObjectSpace.each_object(Piece).to_a
    .select {|el| el.color == color}
  end

  def self.opposite_color(color)
    color == :white ? :black : :white
  end



  def valid_move?(pos)
    return false if ally_piece_blocking?(pos)
    return false if ! in_bounds?(pos)
    return :attack if opponent_piece_blocking?(pos)
    true
    # if ally_piece_blocking?(pos) ||
    #     ! in_bounds?(pos) #|| will_be_in_check?(pos)
    #   false
    # elsif opponent_piece_blocking?(pos)
    #   :attack
    # else
    #   true
    # end
    # in_bounds?(pos) #|| no_piece_blocking?(pos)
  end
  # we are going to model_situation every time we run valid_move?
  # if king is in check in the modelled situation, return valid_move false

  def self.checkmate?(color)
    #access all pieces of the color
    ok_moves = []
    Piece.all_piece_of(color).each do |piece|
      piece.moves.each do |move|
        return false unless piece.will_be_in_check?(move)
        # ok_moves << move unless piece.will_be_in_check?(move)
      end
    end
    # ok_moves.empty?
    true
  end

  def will_be_in_check?(end_pos)
    end_obj = @board[end_pos] #NullPiece  ([6,3], [5,4])
    start_pos = @position
    @position = end_pos
    end_obj.position = []

    result = @board.check?(@color)

    end_obj.position = end_pos
    @position = start_pos

    result
  end

  def ally_piece_blocking?(pos)
    all_piece_positions(@color).include?(pos)
  end

  def opponent_piece_blocking?(pos)
    op_col = Piece.opposite_color(@color)
    all_piece_positions(op_col).include?(pos)
  end

  def in_bounds?(pos)
    x,y = pos
    x.between?(0,7) && y.between?(0,7)
  end

  def all_piece_positions(color)
    ObjectSpace.each_object(Piece).to_a
    .reject {|el| DELETED.include?(el)}
    .select {|el| el.color == color}
    .map(&:position)
  end

  def delete_piece
    @board[position] = NullPiece.instance
    @position = []
    DELETED << self
  end


end

class Pawn < Piece

  def to_s
    @color == :black ? "\u265F" : "\u2659"
  end

  def moves
    return [] if @position.empty?
    possible_moves = []
    move_dirs.each do |dir|
      x = @position.first + dir.first
      y = @position.last + dir.last
      possible_moves << [x,y] if valid_move?([x,y]) == true && valid_move?([x,y]) != :attack
    end

    attack_moves.each do |dir|
      x = @position.first + dir.first
      y = @position.last + dir.last
      possible_moves << [x,y] if valid_move?([x,y]) == :attack
    end

    # attack_moves.select {|move| valid_move?(move) == :attack}
    # move_dirs.select {|move| valid_move?(move) == :attack}
    possible_moves
  end

  def move_dirs
    x = @color == :white ? -1 : 1
    if @position.first == 1 || @position.first == 6
      moves_a = [[x,0],[x*2,0]]
    else
      moves_a = [[x,0]]
    end
  end

  def attack_moves
    x = @color == :white ? -1 : 1
    [[x,-1], [x,1]]
  end

end



class King < Piece

  include SteppingPiece

  def to_s
    @color == :black ? "\u265A" : "\u2654"
  end

  def move_dirs
    DIAGONALLY + HORIZON_VERT
    #[1,-1],[1,1] attack
  end


end

class Knight < Piece

  include SteppingPiece

  def to_s
    @color == :black ? "\u265E" : "\u2658"
  end

  def move_dirs
    [[1,2],[-1,2],[1,-2],[-1,-2],[2,1],[2,-1],[-2,1],[-2,-1]]
  end
end


class Queen < Piece

  # def initialize(board, position)
  #   super
  # end

  include SlidingPiece

  def to_s
    @color == :black ? "\u265B" : "\u2655"
  end

  def move_dirs
    DIAGONALLY + HORIZON_VERT
  end

end

class Rook < Piece

  include SlidingPiece

  def to_s
    @color == :black ? "\u265C" : "\u2656"
  end

  def move_dirs
    HORIZON_VERT
  end

end

class Bishop < Piece

  include SlidingPiece

  def to_s
    @color == :black ? "\u265d" : "\u2657"
  end

  def move_dirs
    DIAGONALLY
  end

end


class NullPiece < Piece
  include Singleton

  def initialize
  end

  def position
    []
  end

  def position=(arg)
    []
  end

  def to_s
    " "
  end

  def moves
    []
  end

end
