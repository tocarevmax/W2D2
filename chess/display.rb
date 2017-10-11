require "colorize"
require_relative "cursor"
require_relative "board"



class Display
  attr_accessor :board, :cursor, :selected_piece
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], @board)
    # @selected_piece = nil
    @error_message = ""
  end

  def render
    system("clear")
    # puts "  0 1 2 3 4 5 6 7"
    puts "  a b c d e f g h"
    @selected_piece = board[@cursor.selected]
    selected_moves = @selected_piece.moves
    @board.grid.each.with_index do |row, x|
      print "#{8-x} "
      row.each.with_index do |sqr,y|
        color = {:background => :light_white} if x % 2 != y % 2
        color = {:background => :light_cyan} if [x, y] == @cursor.selected
        color = {:background => :light_yellow} if selected_moves.include?([x,y])
        color = {:background => :light_green} if [x, y] == @cursor.cursor_pos
        print "#{sqr} ".colorize(color)
      end
      puts ''
    end
    puts "#{@error_message}"
    nil
  end

  # def cursor_move_piece
  #   @board.move_piece(start_pos, end_pos)
  # end

  def get_pos_input
    res = nil
    until res
      render
      res = @cursor.get_input
    end
    res
  end

  def play
    until Piece.checkmate?(:white) || Piece.checkmate?(:black)
      @error_message = ""
      begin
      pos1 = get_pos_input
      pos2 = get_pos_input
      @board.move_piece(pos1, pos2)
    rescue InvalidMove => e
        @error_message = e.message
        puts "invalid move"
        @selected_piece = nil
        retry
      end
    end
    puts "game is over"
  end


end




b= Board.new

display = Display.new(b)
b.generate_pieces
b[[7,7]].delete_piece
b[[7,6]].delete_piece
b[[7,5]].delete_piece
b[[1,7]].delete_piece
b[[7,4]].delete_piece

display.play

# b.move_piece([6,1],[5,0])
# b.move_piece([6,0],[4,0])
# b.move_piece([1,1],[3,1])
# b.move_piece([6,3],[5,3])
# display.render
# b.move_piece([4,0],[3,1])
# b.move_piece([0,3],[2,3])
# b[[5,3]].delete_piece
# b.move_piece([7,2],[6,3])
# display.render
# b[[6,4]].position = []

# b.move_piece([6,3], [5,4])
# display.render
# # print "will be in check? "
# p b.check?(:white)
#
# print "will be in check? "
# p b[[6,3]].will_be_in_check?([5,4])


# b.move_piece([5,3],[6,0])
# display.render
# ObjectSpace.each_object(King).to_a.each do |el|
#   puts "el.color: #{el.color} | el.class: #{el.class}"
# end

#
# remove_pawn = b[[6,7]]
# remove_pawn.position = []
# b[[6,7]] = NullPiece.instance


# queen = b[[0,3]]
# queen.position = [4,4]
# b[[4,4]] = queen
# b[[0,3]] = NullPiece.instance
#
# pawn1 = b[[1,6]]
# pawn1.position = [0,5]
# b[[0,5]] = pawn1
# b[[1,6]] = NullPiece.instance


# display.render





# p b.all_piece_positions(:black)


# whites = ObjectSpace.each_object(Piece).to_a.select {|el| el.color == :white}
# all_white_pos = whites.map(&:position)


# whites.each do |el|
#  puts "#{idx}: class #{el.class} color: #{el.color} pos: #{el.position}"
# #  idx +=1
# end
# p Piece::ALL
# p Bishop.ALL
#  ObjectSpace.each_object(Piece).to_a.each do |el|
#   puts "class #{el.class} color: #{el.color}"
# end
# p bishop.moves


# while true
# display.render
# p display.selected_piece.class
# p b.check?(:white)
#
# p get_pos_input
#
# # display.selected_piece = display[cursor.cursor_pos]
# end
