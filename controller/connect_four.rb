require "io/console"
require_relative "../model/board"
require_relative "../players/human"
require_relative "../players/hal"

class ConnectFour
  def initialize
    @board = Board.new(col: 7, row: 6)
  end

  def play
    system "clear"
    create_players
    puts "STAY A WHILE... STAY FOREVER"
    sleep(2)
    game_loop
  end

  def quit?(move = nil)
    (move || @last_play).to_s.casecmp("q").zero?
  end

  def winner
    return unless @last_move
    winning_state = (board.state_at(*@last_move) * WIN_COUNT).freeze
    @last_player if winning_state_found?(winning_state)
  end

  private

  WIN_COUNT = 4
  attr_reader :board, :players, :last_player, :last_move

  def ask_if_player_is_human(cononical)
    print "Is player #{cononical} human (y/n)? "
    puts answer = STDIN.getch
    answer.casecmp("y").zero?
  end

  def create_players
    @players = [ask_if_player_is_human(1) ? Players::Human.new(board, "Player 1", "X") : Players::Hal.new(board, "Hal 1", "X"),
                ask_if_player_is_human(2) ? Players::Human.new(board, "Player 2", "0") : Players::Hal.new(board, "Hal 2", "0")]
  end

  def game_loop
    draw
    [0, 1].cycle do |player_index|
      @last_player = players[player_index]
      @last_play = player_move(@last_player)
      break if quit?
      @last_move = add_move(@last_play, last_player.symbol)
      draw
      break if board.full? || winner
    end
  end

  def player_prompt(player)
    "\nSelect a column (0 -> #{board.column_count - 1}) or press q to quit\n" + player.next_move_prompt
  end

  def player_move(player)
    print player_prompt(player)
    move = player.next_move
    return move if quit?(move) || valid_move?(move)
    player_move player
  end

  def valid_move?(move)
    if board.empty_at?(0, move.to_i) == false
      puts "\nThat was not a legal move.\nPlease pick a different column "
      false
    elsif board.valid_move?(move) == false
      puts "\nThat was not a legal move."
      false
    else
      true
    end
  end

  def winning_state_found?(winning_state)
    return true if board.horizontal_state(last_move[0]).join.include?(winning_state)
    return true if board.vertical_state(last_move[1]).join.include?(winning_state)
    return true if board.increasing_diagonal_state(*last_move).join.include?(winning_state)
    return true if board.decreasing_diagonal_state(*last_move).join.include?(winning_state)
  end

  def draw
    system "clear"
    puts board.to_s + "\n\n"
    7.times { |n| print "| #{n} " }
    print "|"
  end

  def add_move(col, symbol)
    col = col.to_i
    (board.row_count - 1).downto(0) do |n|
      if board.empty_at?(n, col)
        board.set_state_at(n, col, symbol)
        return [n, col]
      end
    end
    nil
  end
end
