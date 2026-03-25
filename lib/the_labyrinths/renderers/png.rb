require 'chunky_png'

module TheLabyrinths
  module Renderers
    class Png
      def initialize(grid)
        @grid = grid
      end

      def render(filename = 'maze.png', cell_size: 25)
        padding = 4
        width = @grid.cols * cell_size + padding * 2 + 1
        height = @grid.rows * cell_size + padding * 2 + 1
        
        png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)
        
        # внешняя рамка
        (0...width).each do |x|
          png[x, 0] = ChunkyPNG::Color::BLACK
          png[x, height - 1] = ChunkyPNG::Color::BLACK
        end
        (0...height).each do |y|
          png[0, y] = ChunkyPNG::Color::BLACK
          png[width - 1, y] = ChunkyPNG::Color::BLACK
        end
        
        @grid.rows.times do |row|
          @grid.cols.times do |col|
            cell = @grid.cell_at(row, col)
            x = col * cell_size + padding
            y = row * cell_size + padding
            
            # Северная стена
            if cell.north
              (0...cell_size).each do |dx|
                png[x + dx, y] = ChunkyPNG::Color::BLACK
              end
            end
            
            # Западная стена
            if cell.west
              (0...cell_size).each do |dy|
                png[x, y + dy] = ChunkyPNG::Color::BLACK
              end
            end
            
            # Южная стена (последний ряд)
            if cell.south || row == @grid.rows - 1
              (0...cell_size).each do |dx|
                png[x + dx, y + cell_size] = ChunkyPNG::Color::BLACK
              end
            end
            
            # Восточная стена (последняя колонка)
            if cell.east || col == @grid.cols - 1
              (0...cell_size).each do |dy|
                png[x + cell_size, y + dy] = ChunkyPNG::Color::BLACK
              end
            end
          end
        end
        
        png.save(filename)
        filename
      end
    end
  end
end