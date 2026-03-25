<img width="459" height="459" alt="image" src="https://github.com/user-attachments/assets/6412a0db-1693-4db4-b653-88c2862466b7" />
 <img width="459" height="459" alt="image" src="https://github.com/user-attachments/assets/907d43c0-163e-456e-bdac-ae2a00a489e5" />




# Генератор лабиринтов

Ruby-гем для создания лабиринтов с помощью различных алгоритмов. Поддерживает визуализацию в консоли и сохранение в PNG. Может найти кратчайший путь от входа (левая верхняя клетка) до выхода (правая нижняя клетка) с помощью алгоритма BFS.

## Установка

Установите гем:

```bash
$ gem install specific_install
$ gem specific_install https://github.com/DiaboliFelis/the_labyrinths.git
```

Или добавьте в свой Gemfile и запустите bundle install:

```ruby
gem "the_labyrinths", git: "https://github.com/DiaboliFelis/the_labyrinths.git"
```

## Примеры работы:
```ruby
require 'the_labyrinths'

maze = TheLabyrinths.generate(rows: 20, cols: 20)

cell = maze.cell_at(0, 0)

if cell.east
  puts "Можно идти направо"
else
  puts "Стена справа"
end

puts maze.to_ascii

maze.to_png('my_maze.png', cell_size: 30)
```

```ruby
maze = TheLabyrinths.generate(rows: 15, cols: 15)

path = maze.solve
puts "Длина пути: #{path.length} шагов"

puts maze.to_ascii_with_path

maze.to_png_with_path('maze_with_path.png', cell_size: 30)
```

## API

```ruby
maze = TheLabyrinths.generate(rows: 15, cols: 15)
```

| Параметр | Описание | 
|----------------|:---------:|
| rows | Количество рядов | 
| cols | Количество колонок |

| Метод | Описание | 
|----------------|:---------:|
| to_ascii | Возвращает строку с ASCII-изображением лабиринта | 
| to_png(filename, cell_size:) | Сохраняет лабиринт как PNG-картинку |
| cell_at(row, col) | Возвращает клетку по координатам |
| each_cell | Перебирает все клетки лабиринта |
| solve | Возвращает массив координат пути от входа до выхода |
| to_ascii_with_path | Показывает лабиринт с путём в консоли |
| to_png_with_path(filename, cell_size:) | Сохраняет лабиринт с найденным с путём (зелёный вход, красный выход, красный путь) как PNG-картинку |

## Лицензия

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
