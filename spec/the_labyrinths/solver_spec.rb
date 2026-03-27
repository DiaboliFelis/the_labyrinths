require "spec_helper"

RSpec.describe "Поиск пути" do
  let(:maze) { TheLabyrinths.generate(rows: 5, cols: 5) }

  describe "#solve" do
    it "возвращает массив координат" do
      path = maze.solve
      expect(path).to be_a(Array)
      expect(path.first).to eq([0, 0])
      expect(path.last).to eq([4, 4])
    end

    it "каждый шаг пути — соседняя клетка" do
      path = maze.solve
      path.each_cons(2) do |(r1, c1), (r2, c2)|
        # Проверяем, что клетки соседние (разница по одной координате 1, другой 0)
        expect((r1 - r2).abs + (c1 - c2).abs).to eq(1)
      end
    end

    it "путь не проходит сквозь стены" do
      path = maze.solve
      path.each_cons(2) do |(r1, c1), (r2, c2)|
        cell = maze.cell_at(r1, c1)
        if r2 > r1
          expect(cell.south).to be false
        elsif r2 < r1
          expect(cell.north).to be false
        elsif c2 > c1
          expect(cell.east).to be false
        elsif c2 < c1
          expect(cell.west).to be false
        end
      end
    end

    it "находит путь для лабиринта 1x1" do
      tiny = TheLabyrinths.generate(rows: 1, cols: 1)
      path = tiny.solve
      expect(path).to eq([[0, 0]])
    end
  end

  describe "#to_ascii_with_path" do
    it "возвращает строку" do
      expect(maze.to_ascii_with_path).to be_a(String)
    end

    it "содержит символ пути ●" do
      output = maze.to_ascii_with_path
      expect(output).to include("●")
    end
  end
end