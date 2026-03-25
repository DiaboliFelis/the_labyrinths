<img width="384" height="384" alt="image" src="https://github.com/user-attachments/assets/2bdf2f7d-2376-4333-9b9b-0fddb0f7fde6" />


# Генератор лабиринтов

Ruby-гем для создания лабиринтов с помощью различных алгоритмов. Поддерживает визуализацию в консоли и сохранение в PNG.

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

## Пример работы:
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

## API

```ruby
TheLabyrinths.generate(rows: 20, cols: 20)
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

## Лицензия

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
