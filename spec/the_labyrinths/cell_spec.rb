require "spec_helper"

RSpec.describe TheLabyrinths::Cell do
  describe "#initialize" do
    it "создаёт клетку с правильными координатами" do
      cell = described_class.new(2, 3)
      expect(cell.row).to eq(2)
      expect(cell.col).to eq(3)
    end

    it "имеет все стены в начале" do
      cell = described_class.new(0, 0)
      expect(cell.north).to be true
      expect(cell.south).to be true
      expect(cell.east).to be true
      expect(cell.west).to be true
    end

    it "не посещена в начале" do
      cell = described_class.new(0, 0)
      expect(cell.visited).to be false
    end
  end

  describe "#remove_wall" do
    let(:cell) { described_class.new(0, 0) }

    it "убирает северную стену" do
      cell.remove_wall(:north)
      expect(cell.north).to be false
      expect(cell.south).to be true
    end

    it "убирает южную стену" do
      cell.remove_wall(:south)
      expect(cell.south).to be false
    end

    it "убирает восточную стену" do
      cell.remove_wall(:east)
      expect(cell.east).to be false
    end

    it "убирает западную стену" do
      cell.remove_wall(:west)
      expect(cell.west).to be false
    end

    it "вызывает ошибку при неизвестном направлении" do
      expect { cell.remove_wall(:unknown) }.to raise_error(ArgumentError, /Unknown direction/)
    end
  end

  describe "#walls_count" do
    it "возвращает 4 для новой клетки" do
      cell = described_class.new(0, 0)
      expect(cell.walls_count).to eq(4)
    end

    it "возвращает 3 после удаления одной стены" do
      cell = described_class.new(0, 0)
      cell.remove_wall(:north)
      expect(cell.walls_count).to eq(3)
    end

    it "возвращает 2 после удаления двух стен" do
      cell = described_class.new(0, 0)
      cell.remove_wall(:north)
      cell.remove_wall(:south)
      expect(cell.walls_count).to eq(2)
    end
  end
end