# test_ascii.rb
require_relative "lib/the_labyrinths"

puts "Создаём лабиринт 10×10..."
maze = TheLabyrinths.generate(rows: 10, cols: 10)

puts "\n\n\n"
renderer = TheLabyrinths::Renderers::Ascii.new(maze)
puts renderer.render