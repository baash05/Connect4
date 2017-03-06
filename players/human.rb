module Players
  class Human
    attr_reader :board, :name, :symbol
    def initialize(board, name, symbol)
      @board = board
      @name = name
      @symbol = symbol
    end

    def next_move
      STDIN.getch
    end

    def next_move_prompt
      "#{name}, it is your move: "
    end
  end
end
