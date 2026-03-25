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

    # Находит путь от входа (0,0) до выхода (rows-1, cols-1)
    def solve
      start = cell_at(0, 0)
      finish = cell_at(@rows - 1, @cols - 1)
      
      queue = [[start, [start]]]
      visited = { start => true }
      
      while queue.any?
        current, path = queue.shift
        
        if current == finish
          return path.map { |cell| [cell.row, cell.col] }
        end
        
        neighbors(current).each do |neighbor|
          next if visited[neighbor]
          
          if can_move?(current, neighbor)
            visited[neighbor] = true
            queue << [neighbor, path + [neighbor]]
          end
        end
      end
      
      []
    end

    # Показывает лабиринт с отмеченным путём
    def to_ascii_with_path(path = nil)
      path ||= solve
      return to_ascii if path.empty?
      
      result = []
      
      # Верхняя граница
      result << "┌" + "───┬" * (@cols - 1) + "───┐"
      
      @rows.times do |row|
        line = "│"
        @cols.times do |col|
          if path.include?([row, col])
            line += " ● "
          else
            line += "   "
          end
          cell = cell_at(row, col)
          line += cell.east ? "│" : " "
        end
        result << line
        
        if row < @rows - 1
          line = "├"
          @cols.times do |col|
            cell = cell_at(row, col)
            line += cell.south ? "───" : "   "
            line += col < @cols - 1 ? "┼" : "┤"
          end
          result << line
        end
      end
      
      result << "└" + "───┴" * (@cols - 1) + "───┘"
      result.join("\n")
    end

    private

    def can_move?(from, to)
      if from.row == to.row
        # Горизонтальное движение
        if from.col < to.col
          !from.east
        else
          !from.west
        end
      else
        # Вертикальное движение
        if from.row < to.row
          !from.south
        else
          !from.north
        end
      end
    end

  end
end