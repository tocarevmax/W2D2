require_relative "piece.rb"

class InvalidMove < StandardError
end

class Board


  attr_accessor :grid
  def initialize
    @grid = Array.new(8) {Array.new(8) {NullPiece.instance} }
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos,mark)
    x,y = pos
    @grid[x][y] = mark
  end

  def generate_pieces
    back_row = [Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook]
    front_row = [Pawn] * 8
    [:white, :black].each do |color|
      color == :white ? x = 7 : x = 0
      back_row.each_with_index do |piece_class, y|
        place_piece(piece_class, [x,y], color)
      end
      color == :white ? x = 6 : x = 1
      front_row.each_with_index do |pwn, y|
        place_piece(pwn,[x,y], color)
      end
    end
  end

  def place_piece(piece_class, pos, color)
    current_piece = piece_class.new(self, pos, color)
    self[pos] = current_piece
  end

  def move_piece(start_pos, end_pos)

    obj = self[start_pos]
    raise InvalidMove, "Not a Piece" if obj.is_a?(NullPiece)
    raise InvalidMove, "Illegal Move" unless obj.moves.include?(end_pos)
    raise InvalidMove, "Can't Move Into Check" if obj.will_be_in_check?(end_pos)
    obj.position = end_pos
    if ! self[end_pos].is_a?(NullPiece)
      self[end_pos].delete_piece
    end
    self[end_pos] = obj
    self[start_pos] = NullPiece.instance
  end

  def update_last_moves

  end

  def check?(color)
    opposite_color = Piece.opposite_color(color)
    king = ObjectSpace.each_object(King).to_a
          .select {|piece| piece.color == color}.first
    all_moves = []
    Piece.all_piece_of(opposite_color)
      .each {|piece| all_moves += piece.moves}
    all_moves.include?(king.position)
  end




end


# def render
#   @grid.each do |row|
#     row.each do |sqr|
#       print "#{sqr}|"
#     end
#     puts ''
#   end
#   nil
# end
