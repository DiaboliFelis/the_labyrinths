require_relative "lib/the_labyrinths"

puts "Создаём лабиринт 15×15..."
maze = TheLabyrinths.generate(rows: 15, cols: 15)

# test_png.rb
require_relative "lib/the_labyrinths"

puts "Создаём лабиринт 15×15..."
maze = TheLabyrinths.generate(rows: 15, cols: 15)

# Обычный PNG (только вход и выход)
puts "\n1. Сохраняем обычный лабиринт..."
maze.to_png('maze_simple.png', cell_size: 30)
puts "   → maze_simple.png (только вход и выход)"

# Находим путь
path = maze.solve
puts "\n2. Путь найден! Длина: #{path.length} шагов"

# PNG с путём
puts "\n3. Сохраняем лабиринт с путём..."
maze.to_png_with_path('maze_with_path.png', cell_size: 30)
puts "   → maze_with_path.png (зелёный вход, красный выход, красный путь)"

# Показываем в консоли
puts "\n4. Лабиринт в консоли с путём (●):"
puts maze.to_ascii_with_path(path)

puts "\n Готово! Откройте картинки:"
puts "   - maze_simple.png — обычный лабиринт"
puts "   - maze_with_path.png — с найденным путём"

# Показываем в консоли с путём
puts "\nЛабиринт с путём (●):"
puts maze.to_ascii_with_path(path)