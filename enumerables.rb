module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?
    
    0.upto(to_a.length - 1) do |i|
      yield(to_a[i])
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?
    
    0.upto(to_a.length - 1) do |i|
      yield(to_a[i], i)
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?
    
    arr = []
    to_a.my_each { |val| arr << val if yield(val)}

    (is_a? Array)? arr : arr.to_h
  end

  def my_all?
    return true unless block_given?

    to_a.my_each { |val| return false unless yield(val)}
    true
  end
end

names = ["Jane", "John", "Philip", "Emmmanuel"]
hash_names = {:Jane => "1", :John => "2", "Philip" => "3", "Emmmanuel" => "4"}

puts "------my_each-----"
names.my_each { |name| puts "Hello #{name}"}
hash_names.my_each { |k,v| puts "#{k} is #{v}"}
puts "------my_each_with_index-------"
names.my_each_with_index { |name, index| puts "#{name}'s index is #{index}"}
puts "------my_select-------"
p names.my_select { |name| name == "Jane"}
p hash_names.my_select { |k, v| v === "2"}
puts "--------my_all-------"
p names.my_all? { |name| name.length > 4 }
p hash_names.my_all? { |k, v| v.is_a? String }
