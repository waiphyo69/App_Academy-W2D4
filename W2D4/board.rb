
COLUMN = {
           "A" => 0,
           "B" => 1,
           "C" => 2,
           "D" => 3,
           "E" => 4,
           "F" => 5,
           "G" => 6,
           "H" => 7
         }

class Board
  GRID_SIZE = 8
  attr_accessor :grid
  def initialize
    @grid = make_grid
  end

  def make_grid
    board = Array.new(GRID_SIZE){Array.new(GRID_SIZE)}
    fill_last_three_rows(fill_first_three_rows(board))
  end

  def fill_first_three_rows(board)
    idx1 = 0
    while idx1 < 3
      idx2 = 0
      while idx2 < GRID_SIZE
       board[idx1][idx2] = Piece.new(1, self, [ idx1, idx2 ])
       idx2 += 2
      end
      idx1 += 2
    end
    #filling in 2nd row
    j = 1
    while j < GRID_SIZE
     board[1][j] = Piece.new(1, self, [1,j])
     j += 2
    end
    board
  end

  def fill_last_three_rows(board)
    #filling in 1st and 3rd last rows
    idx1 = GRID_SIZE - 3
    while idx1 < GRID_SIZE
      idx2 = 1
      while idx2 < GRID_SIZE
       board[idx1][idx2] = Piece.new(2, self, [ idx1, idx2 ])
       idx2 += 2
      end
      idx1 += 2
    end
    #filling in 2nd row
    j = 0
    while j < GRID_SIZE
     board[GRID_SIZE-2][j] = Piece.new(2, self, [GRID_SIZE - 2,j])
     j += 2
    end
    board
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, el)
    @grid[pos[0]][pos[1]] = el
  end

  def display
    str = @grid.flatten.map{|el| (el.nil?) ? '_' : el.symbol}
    puts "     "+COLUMN.keys.join("  ")
    GRID_SIZE.times do |idx|
      row_first_idx = GRID_SIZE*idx
      puts (idx+1).to_s+'   '+str[row_first_idx .. (row_first_idx + GRID_SIZE-1)].join('  ')
    end
  end

  def team_character_count( team )
    count = 0
    @grid.flatten.each do | el |
      next if el.nil?
      if el.team == team
        count += 1
      end
    count
    end
  end
end
