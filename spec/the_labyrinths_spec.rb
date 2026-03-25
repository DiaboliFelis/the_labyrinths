require "spec_helper"

RSpec.describe TheLabyrinths do
  it "has a version number" do
    expect(TheLabyrinths::VERSION).not_to be nil
  end

  describe ".generate" do
    it "создаёт лабиринт с правильными размерами" do
      maze = TheLabyrinths.generate(rows: 5, cols: 7)
      expect(maze.rows).to eq(5)
      expect(maze.cols).to eq(7)
    end

    it "возвращает Grid" do
      maze = TheLabyrinths.generate(rows: 3, cols: 3)
      expect(maze).to be_a(TheLabyrinths::Grid)
    end

    it "создаёт лабиринт, где все клетки посещены" do
      maze = TheLabyrinths.generate(rows: 4, cols: 4)
      
      maze.each_cell do |cell|
        expect(cell.visited).to be true
      end
    end

    it "работает с разными размерами" do
      expect { TheLabyrinths.generate(rows: 1, cols: 1) }.not_to raise_error
      expect { TheLabyrinths.generate(rows: 2, cols: 2) }.not_to raise_error
      expect { TheLabyrinths.generate(rows: 3, cols: 5) }.not_to raise_error
      expect { TheLabyrinths.generate(rows: 10, cols: 10) }.not_to raise_error
    end
  end
end
