require "spec_helper"

RSpec.describe TheLabyrinths::Generators::RecursiveBacktracker do
  let(:grid) { TheLabyrinths::Grid.new(5, 5) }
  let(:generator) { described_class.new(grid) }

  describe "#generate" do
    it "посещает все клетки лабиринта" do
  generator.generate
  
  grid.each_cell do |cell|
    expect(cell.visited).to be true
  end
end

    it "возвращает ту же сетку" do
      result = generator.generate
      expect(result).to eq(grid)
    end

    it "убирает некоторые стены (создаёт проходы)" do
      generator.generate
      
      # Проверяем, что не все стены остались
      walls_count = 0
      grid.each_cell do |cell|
        walls_count += cell.walls_count
      end
      
      # В лабиринте 5×5 должно быть меньше стен, чем в начале
      # В начале: 25 клеток × 4 стены = 100 стен
      # После генерации: примерно 50-60 стен
      expect(walls_count).to be < 100
      expect(walls_count).to be > 0
    end
  end

  describe "краевые случаи" do
    it "работает с лабиринтом 1×1" do
      small_grid = TheLabyrinths::Grid.new(1, 1)
      small_generator = described_class.new(small_grid)
      
      expect { small_generator.generate }.not_to raise_error
      expect(small_grid.cell_at(0, 0).visited).to be true
    end

    it "работает с лабиринтом 2×2" do
      small_grid = TheLabyrinths::Grid.new(2, 2)
      small_generator = described_class.new(small_grid)
      
      expect { small_generator.generate }.not_to raise_error
      
      # Все клетки должны быть посещены
      small_grid.each_cell do |cell|
        expect(cell.visited).to be true
      end
    end

    it "работает с прямоугольным лабиринтом (3×7)" do
      rect_grid = TheLabyrinths::Grid.new(3, 7)
      rect_generator = described_class.new(rect_grid)
      
      expect { rect_generator.generate }.not_to raise_error
      
      # Все клетки посещены
      rect_grid.each_cell do |cell|
        expect(cell.visited).to be true
      end
    end
  end

  describe "связность лабиринта" do
    it "создаёт связный лабиринт (из любой клетки можно добраться до любой другой)" do
      generator.generate
      
      # Берём стартовую клетку (первую)
      start = grid.cell_at(0, 0)
      
      # Собираем все достижимые клетки через BFS
      reachable = []
      queue = [start]
      visited = { start => true }
      
      while queue.any?
        current = queue.shift
        reachable << current
        
        # Проверяем всех соседей, куда есть проход
        if !current.north && (neighbor = grid.cell_at(current.row - 1, current.col))
          unless visited[neighbor]
            visited[neighbor] = true
            queue << neighbor
          end
        end
        
        if !current.south && (neighbor = grid.cell_at(current.row + 1, current.col))
          unless visited[neighbor]
            visited[neighbor] = true
            queue << neighbor
          end
        end
        
        if !current.west && (neighbor = grid.cell_at(current.row, current.col - 1))
          unless visited[neighbor]
            visited[neighbor] = true
            queue << neighbor
          end
        end
        
        if !current.east && (neighbor = grid.cell_at(current.row, current.col + 1))
          unless visited[neighbor]
            visited[neighbor] = true
            queue << neighbor
          end
        end
      end
      
      # Достижимы должны быть все клетки
      expect(reachable.size).to eq(grid.rows * grid.cols)
    end
  end
end