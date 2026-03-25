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

    # Сохраняет PNG с отмеченным путём
    def to_png_with_path(filename = 'maze_with_path.png', cell_size: 25, path: nil)
      path ||= solve
      return to_png(filename, cell_size) if path.empty?
  
      width = @cols * cell_size + 1
      height = @rows * cell_size + 1
  
      png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)
  
      # Рисуем стены
      @rows.times do |row|
        @cols.times do |col|
          cell = cell_at(row, col)
          x = col * cell_size
          y = row * cell_size
      
          # Северная стена
          if cell.north
            (0...cell_size).each { |dx| png[x + dx, y] = ChunkyPNG::Color::BLACK }
          end
      
          # Западная стена
          if cell.west
            (0...cell_size).each { |dy| png[x, y + dy] = ChunkyPNG::Color::BLACK }
          end
      
          # Южная стена
          if cell.south
            (0...cell_size).each { |dx| png[x + dx, y + cell_size] = ChunkyPNG::Color::BLACK }
          end
      
          # Восточная стена
          if cell.east
            (0...cell_size).each { |dy| png[x + cell_size, y + dy] = ChunkyPNG::Color::BLACK }
          end
        end
      end
  
      # Рисуем путь (красная линия)
      if path.size > 1
        path.each_cons(2) do |(row1, col1), (row2, col2)|
          x1 = col1 * cell_size + cell_size / 2
         y1 = row1 * cell_size + cell_size / 2
         x2 = col2 * cell_size + cell_size / 2
         y2 = row2 * cell_size + cell_size / 2
      
         draw_line(png, x1, y1, x2, y2, ChunkyPNG::Color.rgb(255, 0, 0))
        end
      end
  
      # Отмечаем старт (зелёная точка)
      sx = 0 * cell_size + cell_size / 2
      sy = 0 * cell_size + cell_size / 2
     draw_circle(png, sx, sy, cell_size / 4, ChunkyPNG::Color.rgb(0, 255, 0))
  
     # Отмечаем финиш (красная точка)
     fx = (@cols - 1) * cell_size + cell_size / 2
      fy = (@rows - 1) * cell_size + cell_size / 2
      draw_circle(png, fx, fy, cell_size / 4, ChunkyPNG::Color.rgb(255, 0, 0))
  
     png.save(filename)
      filename
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

    def draw_line(png, x1, y1, x2, y2, color)
      dx = (x2 - x1).abs
      dy = (y2 - y1).abs
      sx = x1 < x2 ? 1 : -1
      sy = y1 < y2 ? 1 : -1
      err = dx - dy
  
     x, y = x1, y1
  
     loop do
       png[x, y] = color
        break if x == x2 && y == y2
        e2 = 2 * err
        if e2 > -dy
          err -= dy
          x += sx
        end
        if e2 < dx
          err += dx
          y += sy
        end
      end
    end

    def draw_circle(png, cx, cy, radius, color)
      (0..radius).each do |dx|
        dy = Math.sqrt(radius * radius - dx * dx).round
        png[cx + dx, cy + dy] = color
        png[cx + dx, cy - dy] = color
        png[cx - dx, cy + dy] = color
        png[cx - dx, cy - dy] = color
        png[cx + dy, cy + dx] = color
        png[cx + dy, cy - dx] = color
        png[cx - dy, cy + dx] = color
        png[cx - dy, cy - dx] = color
      end
    end

  end
end