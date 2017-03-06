require "./controller/connect_four"

RSpec.describe ConnectFour do
  let(:game) { ConnectFour.new }

  describe "initialize" do
    it "should create a new board of size 6 by 7" do
      expect(game.send(:board).row_count).to eq 6
      expect(game.send(:board).column_count).to eq 7
    end
  end
  describe "player selection" do
    it "should set two human players if human selected twice" do
      allow(game).to receive(:ask_if_player_is_human).twice.and_return(true)
      game.send(:create_players)
      expect(game.send(:players)[0]).to be_kind_of(Players::Human)
      expect(game.send(:players)[0]).to be_kind_of(Players::Human)
    end
    it "should set one human and one hal if human and not_human selected" do
      allow(game).to receive(:ask_if_player_is_human).with(1).and_return(true)
      allow(game).to receive(:ask_if_player_is_human).with(2).and_return(false)
      game.send(:create_players)
      expect(game.send(:players)[0]).to be_kind_of(Players::Human)
      expect(game.send(:players)[1]).to be_kind_of(Players::Hal)
    end
  end
  describe "player prompt" do
    let(:player) { double(:dummy_player, next_move_prompt: "snikle_fritz") }
    let(:prompt) { game.send(:player_prompt, player) }
    it "should contain column comment" do
      expect(prompt).to include "Select a column (0 -> 6) or press q to quit"
    end
    it "should contain player specific instructions" do
      expect(prompt).to include "snikle_fritz"
    end
  end
  describe "player move" do
    let(:player) { double(:dummy_player, next_move: "q", next_move_prompt: "hey") }
    it "should print the prompt" do
      allow(game).to receive(:player_prompt).and_return("test")
      expect { game.send(:player_move, player) }.to output("test").to_stdout
    end
    it "should call the players next_move method" do
      expect(player).to receive(:next_move).and_return("q")
      game.send(:player_move, player)
    end
    it "should return q if the player returned quit" do
      expect(game.send(:player_move, player)).to eq "q"
    end
    it "should return 1 if the play is valid" do
      allow(player).to receive(:next_move).and_return("1")
      expect(game.send(:player_move, player)).to eq "1"
    end
  end
  describe "valid_move" do
    it "should return false if value too high" do
      expect(game.send(:valid_move?, 500)).to eq false
    end
    it "should return false if value too low" do
      expect(game.send(:valid_move?, -1)).to eq false
    end
    it "should return false if column full" do
      allow(game.send(:board)).to receive(:empty_at?).and_return(false)
      expect(game.send(:valid_move?, 0)).to eq false
    end
  end

  describe "winning_state_found?" do
    let(:winning_state) { "XXX" }
    before :each do
      allow(game).to receive(:last_move).and_return([0, 0])
    end
    it "should return true if hozontal match" do
      allow(game.send(:board)).to receive(:horizontal_state).and_return(["X"] * 3)
      expect(game.send(:winning_state_found?, winning_state)).to eq true
    end
    it "should return true if vertical match" do
      allow(game.send(:board)).to receive(:vertical_state).and_return(["X"] * 3)
      expect(game.send(:winning_state_found?, winning_state)).to eq true
    end
    it "should return true if upward diagonal match" do
      allow(game.send(:board)).to receive(:increasing_diagonal_state).and_return(["X"] * 3)
      expect(game.send(:winning_state_found?, winning_state)).to eq true
    end
    it "should return true if downward diagonal match" do
      allow(game.send(:board)).to receive(:decreasing_diagonal_state).and_return(["X"] * 3)
      expect(game.send(:winning_state_found?, winning_state)).to eq true
    end
  end
end
