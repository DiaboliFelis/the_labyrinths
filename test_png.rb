require_relative "lib/the_labyrinths"

puts "Создаём лабиринт 15×15..."
maze = TheLabyrinths.generate(rows: 15, cols: 15)

path = maze.solve

if path.any?
  puts "Путь найден! Длина: #{path.length} шагов"
else
  puts "Путь не найден!"
end

# Сохраняем как PNG
puts "Сохраняем PNG..."
maze.to_png('my_maze.png', cell_size: 25)

# Показываем в консоли с путём
puts "\nЛабиринт с путём (●):"
puts maze.to_ascii_with_path(path)