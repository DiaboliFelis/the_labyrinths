require "spec_helper"

RSpec.describe TheLabyrinths::Grid do
  let(:grid) { described_class.new(3, 4) }

  describe "#initialize" do
    it "создаёт сетку с правильными размерами" do
      expect(grid.rows).to eq(3)
      expect(grid.cols).to eq(4)
      expect(grid.cells.size).to eq(3)
      expect(grid.cells[0].size).to eq(4) 
    end

    it "заполняет сетку объектами Cell" do
      expect(grid.cells[0][0]).to be_a(TheLabyrinths::Cell)
      expect(grid.cells[2][3]).to be_a(TheLabyrinths::Cell)
    end

    it "каждая клетка знает свои координаты" do
      cell = grid.cells[1][2]
      expect(cell.row).to eq(1)
      expect(cell.col).to eq(2)
    end
  end

  describe "#cell_at" do
    it "возвращает клетку по правильным координатам" do
      cell = grid.cell_at(1, 2)
      expect(cell).to be_a(TheLabyrinths::Cell)
      expect(cell.row).to eq(1)
      expect(cell.col).to eq(2)
    end

    it "возвращает nil для отрицательных координат" do
      expect(grid.cell_at(-1, 0)).to be_nil
      expect(grid.cell_at(0, -1)).to be_nil
    end

    it "возвращает nil для координат за пределами сетки" do
      expect(grid.cell_at(3, 0)).to be_nil
      expect(grid.cell_at(0, 4)).to be_nil
    end
  end

  describe "#neighbors" do
    it "возвращает 2 соседей для угловой клетки (0,0)" do
      cell = grid.cell_at(0, 0)
      neighbors = grid.neighbors(cell)
      expect(neighbors.size).to eq(2)  # только юг и восток
    end

    it "возвращает 3 соседей для клетки на верхней границе (0,2)" do
      cell = grid.cell_at(0, 2)
      neighbors = grid.neighbors(cell)
      expect(neighbors.size).to eq(3)  # юг, запад, восток
    end

    it "возвращает 3 соседей для клетки на левой границе (1,0)" do
      cell = grid.cell_at(1, 0)
      neighbors = grid.neighbors(cell)
      expect(neighbors.size).to eq(3)  # север, юг, восток
    end

    it "возвращает 4 соседей для центральной клетки (1,2)" do
      cell = grid.cell_at(1, 2)
      neighbors = grid.neighbors(cell)
      expect(neighbors.size).to eq(4)  # север, юг, запад, восток
    end

    it "возвращает правильных соседей для клетки (1,2)" do
      cell = grid.cell_at(1, 2)
      neighbors = grid.neighbors(cell)
      
      # Проверяем координаты соседей
      coords = neighbors.map { |c| [c.row, c.col] }
      expect(coords).to include([0, 2])  # север
      expect(coords).to include([2, 2])  # юг
      expect(coords).to include([1, 1])  # запад
      expect(coords).to include([1, 3])  # восток
    end
  end

  describe "#each_cell" do
    it "перебирает все клетки" do
      count = 0
      grid.each_cell { count += 1 }
      expect(count).to eq(3 * 4)
    end

    it "каждая клетка попадает в блок" do
      visited = Set.new
      grid.each_cell do |cell|
        visited.add([cell.row, cell.col])
      end
      expect(visited.size).to eq(12)
      expect(visited).to include([0, 0], [0, 3], [2, 0], [2, 3])
    end
  end

  describe "#to_png" do
  it "создаёт файл" do
    maze = TheLabyrinths::Grid.new(3, 3)
    filename = "test_maze.png"
    maze.to_png(filename, cell_size: 10)
    expect(File.exist?(filename)).to be true
    File.delete(filename) if File.exist?(filename)
  end
end
end