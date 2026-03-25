module TheLabyrinths
  module Renderers
    class Ascii
      def initialize(grid)
        @grid = grid
      end

      def render
        result = []
        
        # Верхняя граница
        result << "┌" + "───┬" * (@grid.cols - 1) + "───┐"
        
        @grid.rows.times do |row|
          # Ряд с вертикальными стенами
          line = "│"
          @grid.cols.times do |col|
            cell = @grid.cell_at(row, col)
            line += "   "  # для прохода
            line += cell.east ? "│" : " "
          end
          result << line
          
          # Горизонтальные стены между рядами (кроме последнего)
          if row < @grid.rows - 1
            line = "├"
            @grid.cols.times do |col|
              cell = @grid.cell_at(row, col)
              line += cell.south ? "───" : "   "
              line += col < @grid.cols - 1 ? "┼" : "┤"
            end
            result << line
          end
        end
        
        # Нижняя граница
        result << "└" + "───┴" * (@grid.cols - 1) + "───┘"
        
        result.join("\n")
      end
    end
  end
end