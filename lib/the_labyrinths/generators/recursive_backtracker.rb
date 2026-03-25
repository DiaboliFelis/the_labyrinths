module TheLabyrinths
  module Generators
    class RecursiveBacktracker
      def initialize(grid)
        @grid = grid
      end

      def generate
        start_row = rand(@grid.rows)
        start_col = rand(@grid.cols)
        start = @grid.cell_at(start_row, start_col)
        
        #для возврата
        stack = [start]
        start.visited = true
        
        while stack.any?
          current = stack.last
          
          # Находим непосещённых соседей
          unvisited_neighbors = @grid.neighbors(current).select { |n| !n.visited }
          
          if unvisited_neighbors.any?
            # Выбираем случайного
            next_cell = unvisited_neighbors.sample
            
            # Убираем стену между текущей и следующей клеткой
            remove_walls_between(current, next_cell)
            
            # Отмечаем как посещённую и идём в неё
            next_cell.visited = true
            stack.push(next_cell)
          else
            # Возвращаемся назад
            stack.pop
          end
        end
        
        @grid
      end

      private

      def remove_walls_between(cell1, cell2)
        # Определяем направление и убираем стены
        if cell1.row == cell2.row
          if cell1.col < cell2.col
            cell1.east = false
            cell2.west = false
          else
            cell1.west = false
            cell2.east = false
          end
        else
          if cell1.row < cell2.row
            cell1.south = false
            cell2.north = false
          else
            cell1.north = false
            cell2.south = false
          end
        end
      end
    end
  end
end