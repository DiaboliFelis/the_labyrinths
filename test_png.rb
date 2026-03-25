require_relative "lib/the_labyrinths"

puts "Создаём лабиринт 15×15..."
maze = TheLabyrinths.generate(rows: 15, cols: 15)

# Сохраняем как PNG
puts "Сохраняем PNG..."
maze.to_png('my_maze.png', cell_size: 25)

# Показываем в консоли
puts "\n Готово! Файл: my_maze.png"
puts "А вот так он выглядит в консоли:\n\n"
puts maze.to_ascii