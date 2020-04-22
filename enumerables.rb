module Enumerable
  def my_each
    return enum_for unless block_given?

    elements = is_a?(Range) ? to_a : self
    index = 0
    elements.size.times do
      yield(elements[index])
      index += 1
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    elements = is_a?(Range) ? to_a : self
    index = 0
    size.times do
      yield(elements[index], index)
      index += 1
    end
  end

  def my_select(&array)
    return enum_for unless block_given?

    selected_items = []
    my_each do |x|
      selected_items.push(x) unless array.call(x) == false
    end
    selected_items
  end

  def my_all?(*array)
    array = nil
    if array
      my_each { |x| return false unless array == x }
    elsif !block_given?
      my_each { |x| return false unless x }
    else
      my_each { |x| return false unless yield(x) }
    end
    true
  end

  def my_any?(*args)
    args = nil
    if args
      my_each { |x| return true if x == args }
    end
    if !block_given?
      my_each { |x| return true if x }
    else
      my_each { |x| return false unless x == yield(x) }
    end
    false
  end

  def my_none?(*args, &block)
    !my_any?
  end

  def my_count(arguement = nil)
    counter = 0
    if arguement
      my_each { |x| counter += 1 if x == arguement }
    elsif block_given?
      my_each { |x| counter += 1 if yield(x) }
    else
      counter = length
    end
    counter
  end

  def my_map(proc = nil)
    return to_enum unless block_given?

    selected = []
    if proc
      my_each { |x| selected.push(proc.call(x)) }
    else
      my_each { |x| selected.push(yield(x)) }
    end
    selected
  end

  def my_inject(*args, &block)
    element = nil
    symbol = nil
    element = element.to_sym if element.is_a?(String) && !Symbol && !Block
    if element.is_a?(Symbol) && !symbol
      block = element.to_proc
      element = nil
    end
    symbol = symbol.to_sym if symbol.is_a?(String)
    block = symbol.to_proc if symbol.is_a?(Symbol)
    my_each { |x| element = element.nil? ? x : block.yield(element, x) }
    element
  end
end

  def multiply_els(*item)
    arrays = Array
    array = arrays(item)
    array.my_inject { |item1, item2| item1 * item2 }
  end

array = [false, true, false, nil, []]
    puts array.my_any? # should print true
    #puts array.my_all? # should print false
  #puts array.my_none? # should print false
  #array = [7,8,9,5,1,0,2,4,0,1]
p array.my_count(0) == array.count(0) # false
words = %w[dog door rod blade]
  # puts words.my_all?(/c/) == words.all?(/c/) # false
  # puts words.my_any?(/c/) == words.all?(/c/) # false
  # puts words.my_none?(/c/) == words.all?(/c/) # true
  array = [1,7,8,89,9,6,5,12,4,2,5]
  #p array.my_inject(:+) == array.inject(:+) 