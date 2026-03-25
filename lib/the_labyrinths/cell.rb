module TheLabyrinths
  class Cell
    attr_reader :row, :col
    attr_accessor :north, :south, :east, :west, :visited

    # Создаём новую клетку с координатами
    def initialize(row, col)
      @row = row
      @col = col
      @north = @south = @east = @west = true
      @visited = false
    end

    # Убираем стену в указанном направлении
    def remove_wall(direction)
      case direction
      when :north then @north = false
      when :south then @south = false
      when :east  then @east = false
      when :west  then @west = false
      else
        raise ArgumentError, "Unknown direction: #{direction}"
      end
    end

    # Сколько стен осталось у клетки
    def walls_count
      [@north, @south, @east, @west].count(true)
    end
  end
end