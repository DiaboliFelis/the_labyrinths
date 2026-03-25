require_relative "lib/the_labyrinths"

puts "Создаём лабиринт 15×15..."
maze = TheLabyrinths.generate(rows: 15, cols: 15)

puts "Сохраняем PNG..."
renderer = TheLabyrinths::Renderers::Png.new(maze)
filename = renderer.render('my_maze.png', cell_size: 25)

puts "Готово! Файл: #{filename}"
puts "Открой его в просмотрщике изображений"