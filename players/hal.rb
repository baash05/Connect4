module Players
  class Hal
    attr_reader :board, :name, :symbol
    def initialize(board, name, symbol)
      @board = board.freeze
      @name = name.freeze
      @symbol = symbol.freeze
    end

    def next_move
      sleep 1 # A small pause felt better
      rand board.column_count
    end

    def next_move_prompt
      "#{name} is thinking...."
    end
  end
end
