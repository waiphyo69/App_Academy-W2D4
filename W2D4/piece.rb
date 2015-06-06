# encoding: utf-8
require 'byebug'
require 'colorize'
class Piece
  attr_reader   :team, :symbol
  attr_accessor :position, :board, :king

  TOP_SLIDE = [
                [  1,  1],
                [  1, -1]
              ]

  BOTTOM_SLIDE = [
                  [ -1,  1],
                  [ -1, -1]
                 ]

  TOP_JUMP = [
              [  2,  2],
              [  2, -2]
             ]


  BOTTOM_JUMP = [
                  [ -2,  2],
                  [ -2, -2]
                 ]


  def initialize( team, board, position, king = false)
    @team = team
    @board = board
    @position = position
    @king = king
  end

  def symbol
    if team == 1 && @king
      "●".colorize(:blue)
    elsif team == 1
      "○".colorize(:blue)
    elsif @king
      "●".colorize(:black)
    else
      "○".colorize(:black)
    end
  end


  def slide_dirs
    if team == 1
      TOP_SLIDE
    elsif team == 2
      BOTTOM_SLIDE
    else
      raise "Not a valid team"
    end
  end

  def jump_dirs
    if team == 1
      TOP_JUMP
    elsif team == 2
      BOTTOM_JUMP
    else
      raise "Not a valid team"
    end
  end


  def king_slide_dirs
    TOP_SLIDE + BOTTOM_SLIDE
  end


  def king_jump_dirs
    TOP_JUMP + BOTTOM_JUMP
  end


  def enemy_dir(jump_pos)
    jum_pos[0] - board.pos
  end


  def possible_slide_moves
    slide_moves = []

    if self.king

      king_slide_dirs.each do | slide |
        new_pos = [ self.position[0] + slide[0], self.position[1] + slide[1] ]
        next if !in_bounds?( new_pos )
        slide_moves << new_pos if self.board[new_pos] == nil
      end
      slide_moves
    else
      slide_dirs.each do | slide |
        new_pos = [ self.position[0] + slide[0], self.position[1] + slide[1] ]
        slide_moves << new_pos if self.board[new_pos] == nil
      end
      slide_moves.select{| move | in_bounds?( move) }
    end
  end

  def possible_jump_moves
    jump_moves = []

    if self.king

      king_jump_dirs.each_with_index do | jump, idx |
        new_pos =  [ self.position[0] + jump[0], self.position[1] +  jump[1] ]
        next if !in_bounds?( new_pos )
        enemy_dir = king_slide_dirs[idx]
        enemy_pos = [ self.position[0] + enemy_dir[0], self.position[1] + enemy_dir[1] ]
        if self.board[new_pos] == nil && enemy?(enemy_pos)
          jump_moves << new_pos
        end
      end
      jump_moves
   else

      jump_dirs.each_with_index do | jump, idx |
        new_pos =  [ self.position[0] + jump[0], self.position[1] +  jump[1] ]
        enemy_dir = slide_dirs[idx]
        enemy_pos = [ self.position[0] + enemy_dir[0], self.position[1] + enemy_dir[1] ]
        if self.board[new_pos] == nil && enemy?(enemy_pos)
          jump_moves << new_pos
        end
      end
      jump_moves.select{ | move | in_bounds?( move ) }
    end
  end


  def perform_jump( pos )
    direction_taken = [ pos[0] - self.position[0] , pos[1] - self.position[1] ]
    if self.king
      enemy_dir = king_slide_dirs[king_jump_dirs.find_index(direction_taken)]
      enemy_pos = [ self.position[0] + enemy_dir[0], self.position[1] + enemy_dir[1] ]
      self.board[pos] = self
      self.board[enemy_pos] = nil
      self.board[self.position] = nil
      self.position = pos
    else
      #debugger
      enemy_dir = slide_dirs[jump_dirs.find_index(direction_taken)]
      enemy_pos = [ self.position[0] + enemy_dir[0], self.position[1] + enemy_dir[1] ]
      self.board[pos] = self
      self.board[enemy_pos] = nil
      self.board[self.position] = nil
      self.position = pos
    end
  end

  def perform_slide( pos )
   self.board[pos] = self
   self.board[self.position] = nil
   self.position = pos
  end

  def enemy? ( pos )
    return false if self.board[pos].nil?
    team != self.board[pos].team
  end


  def king?
    self.position[0] == 0 if team == 2
    self.position[0] == 7 if team == 1
  end

  def in_bounds?( move )
    move[0].between?(0,7) && move[1].between?(0,7)
  end
end
