require 'bundler/setup'
require 'stamp'

#  todo items
class Todo
  DONE_MARKER = 'X'.freeze
  UNDONE_MARKER = ' '.freeze

  attr_accessor :title, :description, :done, :due_date

  def initialize(title, description = '')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    result = "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
    result += due_date.stamp(' (Due: Friday January 6)') if due_date
    result
  end

  def ==(other)
    title == other.title &&
      description == other.description &&
      done == other.done
  end
end

# TodoList items
class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    raise TypeError.new('Can only add Todo objects'), 'Can only add Todo objects' unless todo.instance_of? Todo

    todos << todo
  end

  def <<(todo)
    add(todo)
  end

  def size
    todos.size
  end

  def first
    todos.first
  end

  def last
    todos.last
  end

  def to_a
    todos.clone
  end

  def done?
    todos.all?(&:done?)
  end

  def item_at(idx)
    todos.fetch(idx)
  end

  def mark_done_at(idx)
    item_at(idx).done!
  end

  def mark_undone_at(idx)
    item_at(idx).undone!
  end

  def done!
    todos.each_index { |idx| mark_done_at(idx) }
  end

  def shift
    todos.shift
  end

  def pop
    todos.pop
  end

  def remove_at(idx)
    todos.delete_at(idx)
  end

  def to_s
    text = "---- #{title} ----\n"
    text << todos.map(&:to_s).join("\n")
  end

  def each
    todos.each { |item| yield(item) }
    self
  end

  def select
    list = TodoList.new(title)
    each { |item| list << item if yield(item) }
    list
  end

  def find_by_title(title)
    select { |item| item.title.downcase == title.downcase }.first
  end

  def all_done
    select(&:done?)
  end

  def all_not_done
    select { |item| !item.done? }
  end

  def mark_done(title)
    find_by_title(title) && find_by_title(title).done!
  end

  def mark_all_done
    done!
  end

  def mark_all_undone
    each(&:done?)
  end

  private

  attr_reader :todos
end

paper = Todo.new("toilet paper")
pin = Todo.new("pineapple")
milk = Todo.new("milk")
eggs = Todo.new("eggs")
list = [paper,pin,milk,eggs]

grocery_list = TodoList.new("Grocery List")
list.each {|todo| grocery_list.add(todo)}

puts grocery_list

grocery_list.mark_done_at(1)

puts grocery_list

puts grocery_list.all_not_done