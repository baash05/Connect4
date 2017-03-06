class Board
  EMPTY = " ".freeze

  def initialize(col:, row:)
    raise "Column cannot be less than 1" if col.to_i < 1
    raise "Row cannot be less than 1" if row.to_i < 1
    @state = Array.new(row) { [EMPTY] * col }
  end

  def row_count
    @state&.size
  end

  def column_count
    @state&.first&.size
  end

  def valid_move?(move)
    return false unless move.to_s =~ /^(\d)+$/
    return false if move.to_i.negative?
    return false if move.to_i >= column_count
    true
  end

  def full?
    @state.each do |row|
      row.each do |played|
        return false if played == EMPTY
      end
    end
    true
  end

  def to_s
    @state && @state.map do |row|
      "| " + row.join(" | ") + " |"
    end.join("\n")
  end

  def empty_at?(row, column)
    state_at(row, column) == Board::EMPTY
  end

  def state_at(row, column)
    (@state[row] || [])[column]
  end

  def set_state_at(row, column, val)
    @state[row] && @state[row][column] = val
  end

  def horizontal_state(row)
    @state[row]
  end

  def vertical_state(column)
    return nil if column >= column_count
    @state.each.map { |row| row[column] }
  end

  def increasing_diagonal_state(row, column)
    column += row
    Array.new(row_count) { |n| state_at(n, column - n) }.compact
  end

  def decreasing_diagonal_state(row, column)
    column -= row
    Array.new(row_count) { |n| state_at(n, column + n) }.compact
  end
end
