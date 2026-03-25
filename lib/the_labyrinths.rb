# frozen_string_literal: true

require_relative "the_labyrinths/version"
require_relative "the_labyrinths/cell"
require_relative "the_labyrinths/grid"
require_relative "the_labyrinths/generators/recursive_backtracker"
require_relative "the_labyrinths/renderers/ascii"

module TheLabyrinths
  class Error < StandardError; end
  
  def self.generate(rows:, cols:)
    grid = Grid.new(rows, cols)
    generator = Generators::RecursiveBacktracker.new(grid)
    generator.generate
    grid
  end
end
