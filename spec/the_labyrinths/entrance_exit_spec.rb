require "spec_helper"

RSpec.describe "Вход и выход" do
  let(:maze) { TheLabyrinths.generate(rows: 5, cols: 5) }

  it "у входа (0,0) убрана северная стена" do
    cell = maze.cell_at(0, 0)
    expect(cell.north).to be false
  end

  it "у выхода (4,4) убрана южная стена" do
    cell = maze.cell_at(4, 4)
    expect(cell.south).to be false
  end
end