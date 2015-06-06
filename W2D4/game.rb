require_relative 'board.rb'
require_relative 'piece.rb'
require 'byebug'
class Game

  attr_accessor :board, :team

  def initialize
    @board = Board.new
    @team = 1
  end



  def choose_from_pos
    loop do
      puts "Team #{self.team}, Please choose the item you want to move"
      start_pos = gets.chomp.strip.split('')
      if start_pos.empty? || !COLUMN.keys.include?(start_pos[0]) || start_pos.length > 2
        puts "Not a valid input. Please try again"
        redo
      end
      start_pos = start_pos[1].to_i - 1 , COLUMN[start_pos[0]]
      if self.board[start_pos].nil?
        puts "There is nothing in this spot"
        redo
      elsif self.team != self.board[start_pos].team
        puts "You cannot move the other team's items."
        redo
      end
      return start_pos
    end
  end

  def choose_two_pos
    start_pos = choose_from_pos
    loop do
      puts "Team #{self.team}, Please choose the position you wish to go"
      end_pos = gets.chomp.strip.split('')
      if end_pos.empty? || !COLUMN.keys.include?(end_pos[0]) || end_pos.length > 2
        puts "Not a valid input. Please try again"
        redo
      end
      end_pos = end_pos[1].to_i - 1 , COLUMN[end_pos[0]]
      if (!self.board[start_pos].possible_jump_moves.include?(end_pos)) &&
          (!self.board[start_pos].possible_slide_moves.include?(end_pos))
        puts "This is an invalid move. Try again"
        redo
      end
      return [start_pos, end_pos]
    end
  end


  def play
      loop do
        self.board.display
        if self.board.team_character_count( self.team ) == 0
          puts "You lose. You have no items anymore"
          break
        end
        two_pos = choose_two_pos
        if self.board[two_pos[0]].possible_jump_moves.include?( two_pos[1] )
          self.board[two_pos[0]].perform_jump(two_pos[1])
          if self.board[two_pos[1]].king?
            self.board[two_pos[1]].king = true
          end
        elsif self.board[two_pos[0]].possible_slide_moves.include?( two_pos[1] )
          self.board[two_pos[0]].perform_slide(two_pos[1])
          if self.board[two_pos[1]].king?
            self.board[two_pos[1]].king == true
            debugger
          end
        end
        self.board.display
        self.team = ( self.team == 1 ? 2 : 1)
      end
   end

end
