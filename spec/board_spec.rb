require "./model/board"
require "pry"
RSpec.describe Board do
  describe "initialize" do
    it "should raise exception if col < 1" do
      expect { Board.new(row: 1, col: 0) }.to raise_error(RuntimeError, "Column cannot be less than 1")
    end
    it "should raise exception if row <1" do
      expect { Board.new(row: 0, col: 1) }.to raise_error(RuntimeError, "Row cannot be less than 1")
    end
  end

  describe "valid_move?"
  describe "full?" do
    let(:board) { Board.new(row: 2, col: 2) }
    it "should return false if there is an empty" do
      board.instance_variable_get(:@state).replace([["0", Board::EMPTY], %w(0 0)])
      expect(board.full?).to be_falsy
    end
    it "should return true if there are no empties" do
      board.instance_variable_get(:@state).replace([%w(0 0), %w(0 0)])
      expect(board.full?).to be_truthy
    end
  end

  describe "state accessors" do
    let(:board) { Board.new(row: 2, col: 2) }
    before do
      board.instance_variable_get(:@state).replace([%w(a b), %w(c d)])
    end

    describe "horizontal_state" do
      it "should return the array for row 0" do
        expect(board.horizontal_state(0)).to eq %w(a b)
      end
      it "should return nil for row n" do
        expect(board.horizontal_state(2)).to eq nil
      end
    end

    describe "vertical_state" do
      it "should return the array for column 0" do
        expect(board.vertical_state(0)).to eq %w(a c)
      end
      it "should return nil for row n" do
        expect(board.vertical_state(2)).to eq nil
      end
    end

    describe "increasing_diagonal_state" do
      it "should return a d for 0,0" do
        expect(board.increasing_diagonal_state(0, 0)).to eq %w(a d)
      end
      it "should return b, c for 1, 0" do
        expect(board.increasing_diagonal_state(1, 0)).to eq %w(b c)
      end
      it "should return d for 1, 1" do
        expect(board.increasing_diagonal_state(1, 1)).to eq %w(d)
      end
    end

    describe "decreasing_diagonal_state" do
      it "should return a for 0,0" do
        expect(board.decreasing_diagonal_state(0, 0)).to eq %w(a d)
      end
      it "should return b for 0, 1" do
        expect(board.decreasing_diagonal_state(0, 1)).to eq %w(b)
      end
      it "should return d for 1, 1" do
        expect(board.decreasing_diagonal_state(1, 1)).to eq %w(a d)
      end
    end
  end
end
