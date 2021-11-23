require 'bundler/setup'
require 'minitest/autorun'
require 'date'
require "minitest/reporters"
Minitest::Reporters.use!


require_relative '../lib/todolist_project'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [todo1, todo2, todo3]
    @todos2 = [todo2, todo3]
    @todos3 = [todo1, todo2]
    @todos4 = [todo1, todo2, todo3, todo1]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(todos, list.to_a)
  end
  
  def test_size
    assert_equal(3, list.size)
  end
  
  def test_first
    assert_equal(todo1, list.first)
  end
  
  def test_last
    assert_equal(todo3, list.last)
  end
  
  def test_shift
    assert_equal(todo1, list.shift)
    assert_equal(todos2, list.to_a)
  end
  
  def test_pop
    assert_equal(todo3, list.pop)
    assert_equal(todos3, list.to_a)
  end
  
  def test_done?
    assert_equal(false, list.done?)
  end
  
  def test_raise_TypeError_not_ToDo_obj
    assert_raises(TypeError) { list.add(3) }
    assert_raises(TypeError) { list.add("hi") }
  end
  
  def test_shovel
    assert_equal(todos4, list << todo1)
  end
  
  def test_add
    assert_equal(todos4, list << todo1)
  end
  
  def test_item_at
    assert_equal(todo2, list.item_at(1))
    assert_equal(todo3, list.item_at(2))
    assert_raises(IndexError) {list.item_at(100)}
  end
  
  def test_mark_done_at
    assert_raises(IndexError) {list.mark_done_at(100) }
    list.mark_done_at(0)
    assert_equal(true, todo1.done?)
    assert_equal(false, todo2.done?)
    assert_equal(false, todo3.done?)
  end
  
  def test_mark_undone_at
    assert_raises(IndexError) {list.mark_done_at(3) }
    todo1.done!
    list.mark_undone_at(0)
    assert_equal(false, todo1.done?)
    assert_equal(false, todo2.done?)
    assert_equal(false, todo3.done?)
  end
  
  def test_done!
    list.done!
    assert_equal(true, todo1.done?)
    assert_equal(true, todo2.done?)
    assert_equal(true, todo3.done?)
    assert_equal(true, list.done?)
  end
  
  def test_mark_all_done
    list.mark_all_done
    assert_equal(true, todo1.done?)
    assert_equal(true, todo2.done?)
    assert_equal(true, todo3.done?)
    assert_equal(true, list.done?)
  end
  
  def test_mark_all_undone
    list.mark_all_undone
    assert_equal(false, todo1.done?)
    assert_equal(false, todo2.done?)
    assert_equal(false, todo3.done?)
    assert_equal(false, list.done?)
  end
  
  def test_mark_done_no_match
    list.mark_done("buymilk")
    assert_equal(false, todo1.done?)
    assert_equal(false, todo2.done?)
    assert_equal(false, todo3.done?)
    assert_equal(false, list.done?)
  end
  
  def test_mark_done
    list.mark_done("Buy milk")
    assert_equal(true, todo1.done?)
    assert_equal(false, todo2.done?)
    assert_equal(false, todo3.done?)
    assert_equal(false, list.done?)
  end
  
  def test_mark_done
    list.mark_done("buy MilK")
    assert_equal(true, todo1.done?)
    assert_equal(false, todo2.done?)
    assert_equal(false, todo3.done?)
    assert_equal(false, list.done?)
  end
  
  def test_remove_at
    assert_raises(IndexError) {list.remove_at(3) }
    list.remove_at(0)
    assert_equal(todos2, list.to_a)
  end
  
  def test_remove_at
    list.add(todo1)
    list.remove_at(0)
    assert_equal([todo2,todo3,todo1],list.to_a)
  end
  
  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
  
    assert_equal(output, @list.to_s)
  end
  
  def test_to_s_todo_done
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
    
    list.mark_done_at(0)
    
    assert_equal(output, @list.to_s)
  end
  
  def test_to_s_done!
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT
    
    list.done!
    
    assert_equal(output, @list.to_s)
  end
  
  def test_each_iterate
    new_array = []
    i = 0
    list.each do
      new_array << i
      i += 1
    end
    assert_equal([0,1,2], new_array)
  end
  
  def test_each_return_original
    assert_same(list, list.each{|i| i.done!})
  end
  
  def test_select_return_new
    refute_same(list, list.select{|i| i.done?})
  end
  
  def test_select
    todo1.done!
    todo2.done!
    assert_equal(todos3, list.select{|i| i.done?}.to_a)
  end
  
  def test_all_done
    a_list = TodoList.new("")
    a_list.add(todo3)
    list.mark_done_at(2)
    assert_equal(a_list.to_a,list.all_done.to_a)
  end
  
  def test_all_done_return_list
    assert_instance_of(TodoList, list.all_done)
  end
  
  def test_all_undone
    a_list = TodoList.new("")
    a_list.add(todo1)
    a_list.add(todo2)
    list.mark_done_at(2)
    assert_equal(a_list.to_a,list.all_not_done.to_a)
  end
  
  def test_all_undone_return_list
    assert_instance_of(TodoList, list.all_not_done)
  end
  
  def test_find_by_title
    assert_equal(todo1, list.find_by_title("Buy milk"))
    assert_equal(nil,   list.find_by_title("a cow"))
  end
  
  def test_no_due_date
    assert_nil(@todo1.due_date)
  end

  def test_due_date
    due_date = Date.today + 3
    @todo2.due_date = due_date
    assert_equal(due_date, @todo2.due_date)
  end
  
  def test_to_s_with_due_date
    @todo2.due_date = Date.civil(2017, 4, 15)
    output = <<-OUTPUT.chomp.gsub(/^\s+/, '')
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room (Due: Saturday April 15)
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end
  
  private
  attr_reader :todo1, :todo2, :todo3, :todos, :list, :todos2, :todos3, :todos4
end