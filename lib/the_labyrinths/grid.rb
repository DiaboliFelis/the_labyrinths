module TheLabyrinths
  class Grid
  attr_reader :rows, :cols, :cells

  # Создаём новую сетку с заданным количеством рядов и колонок
  def initialize(rows, cols)
    @rows = rows
    @cols = cols
      
    # Создаём двумерный массив клеток
    @cells = Array.new(rows) do |row|
      Array.new(cols) do |col|
        Cell.new(row, col)
      end
    end
  end

    def each_cell
      @cells.each do |row|
        row.each do |cell|
          yield cell
        end
      end
    end

  # Получить клетку по координатам
    def cell_at(row, col)
      return nil unless row.between?(0, @rows - 1) && col.between?(0, @cols - 1)
      @cells[row][col]
    end

    # Найти всех соседей клетки
    def neighbors(cell)
      neighbors = []
      
      neighbors << cell_at(cell.row - 1, cell.col) if cell.row > 0
      neighbors << cell_at(cell.row + 1, cell.col) if cell.row < @rows - 1
      neighbors << cell_at(cell.row, cell.col - 1) if cell.col > 0
      neighbors << cell_at(cell.row, cell.col + 1) if cell.col < @cols - 1
      
      neighbors.compact
    end
  
    def to_ascii
      Renderers::Ascii.new(self).render
    end
  
    def to_png(filename = 'maze.png', cell_size: 25)
  Renderers::Png.new(self).render(filename, cell_size: cell_size)
end

  end
end