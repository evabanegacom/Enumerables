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

  def my_all(*args)
    my_each do |x|
      return false unless block_given?

      return true unless yield(x)
    end
    true
  end

  def my_any?(*args)
    args = nil
    if args
      my_each { |x| return false unless x == args }
    end
    if !block_given?
      my_each { |x| return true if x }
    else
      my_each { |x| return true if x == yield(x) }
    end
    false
  end

  def my_none(*args)
    !my_any?
  end

  def my_count(*arguement)
    counter = 0
    arguement = nil
    if arguement
      my_each { |x| counter += 1 if x == arguement }
    elsif block_given?
      my_each { |x| counter += 1 if yield x }
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


p ['d','d'].all?(/d/)
p [1,1,1].all?(Integer)