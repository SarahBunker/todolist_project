require 'bundler/setup'
require 'stamp'

# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done, :due_date

  def initialize(title, description='')
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

  def to_s # replaces original #to_s method
    result = "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
    result += due_date.stamp(' (Due: Friday January 6)') if due_date
    result
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end


# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    raise TypeError.new("Can only add Todo objects") unless todo.instance_of? Todo
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
    todos.all?{|todo| todo.done?}
  end
  
  def item_at(i)
    todos.fetch(i)
  end
  
  def mark_done_at(i)
    item_at(i).done!
  end
  
  def mark_undone_at(i)
    item_at(i).undone!
  end
  
  def done!
    todos.each_index{|i| mark_done_at(i)}
  end
  
  def shift
    todos.shift
  end
  
  def pop
    todos.pop
  end
  
  def remove_at(i)
    # todos.delete(item_at(i))
    item_at(i)
    todos.delete_at(i)
  end
  
  def to_s
    text = "---- #{title} ----\n"
    text << todos.map(&:to_s).join("\n")
  end
  
  def each
    todos.each{|item| yield(item) }
    self
  end
  
  def select
    list = TodoList.new(title)
    each{|item| list << item if yield(item)}
    list
  end
  
  def find_by_title(title)
    select{|item| item.title.downcase == title.downcase}.first
  end
  
  def all_done
    select{|item| item.done?}
  end
  
  def all_not_done
    select{|item| !item.done?}
  end
  
  def mark_done(title)
    find_by_title(title) && find_by_title(title).done!
  end
  
  def mark_all_done
    done!
  end
  
  def mark_all_undone
    each{|item| item.undone!}
  end
  
  private
  attr_reader :todos
end