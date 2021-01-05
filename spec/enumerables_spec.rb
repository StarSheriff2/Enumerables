require_relative '../lib/enumerables'

describe Enumerable do
  let(:strings) { %w[john david peter] }
  let(:numbers) { [1, 2, 3] }

  describe '#my_each' do
    context 'when no block is given' do
      it 'returns enumerator' do
        result = strings.my_each
        expect(result).to be_instance_of(Enumerator)
      end
    end

    context 'when a block is given' do
      it 'returns an array' do
        result = strings.my_each { |item| item }
        expect(result).to be_instance_of(Array)
      end

      it 'calls the given block once for each element and returns array itself' do
        result = numbers.my_each { |number| number * 2 }
        expect(result).to eq([1, 2, 3])
      end

      it 'calls the given block once for each element and does not return a new array' do
        result = numbers.my_each { |number| number * 2 }
        expect(result).to_not eq([2, 4, 6])
      end

      it 'calls the given block once for each element, passing that element as a parameter' do
        arr = []
        numbers.my_each { |number| arr << number * 2 }
        expect(arr).to eq([2, 4, 6])
      end
    end
  end

  describe '#my_each_with_index' do
    context 'when no block is given' do
      it 'returns enumerator' do
        result = strings.my_each_with_index
        expect(result).to be_instance_of(Enumerator)
      end
    end

    context 'when a block is given' do
      it 'returns array itself' do
        result = numbers.my_each_with_index { |number| number * 2 }
        expect(result).to eq([1, 2, 3])
      end

      it 'calls block with two arguments, the item and its index, for each item in enum' do
        hash = {}
        strings.my_each_with_index { |item, index| hash[item] = index }
        expect(hash).to eq({ 'john' => 0, 'david' => 1, 'peter' => 2 })
      end
    end
  end

  describe '#my_select' do
    it 'returns an array containing all elements for which the given block returns a true value' do
      result = numbers.select(&:even?)
      expect(result).to eq([2])
    end

    it 'works with strings, returning elements for which the given block returns a true value' do
      result = strings.my_select { |name| name == 'david' }
      expect(result).to eq(['david'])
    end

    context 'when no block is given' do
      it 'returns an enumerator' do
        result = numbers.my_select
        expect(result).to be_instance_of(Enumerator)
      end
    end
  end

  describe '#my_all?' do
    it 'returns true if the block never returns false or nil' do
      result = strings.my_all? { |word| word.length >= 4 }
      expect(result).to be(true)
    end

    context 'when no block is given' do
      it 'returns true when none of the collection members are false or nil' do
        result = [nil, true, 99].my_all?
        expect(result).to_not be(true)
      end

      context 'when argument is provided' do
        it 'returns whether pattern === element for every collection member if pattern is supplied' do
          result = %w[ant bear cat].my_all?(/t/)
          expect(result).to_not be(true)
        end

        it 'returns true if object type in argument is true for all elements' do
          result = strings.my_all?(Numeric)
          expect(result).to_not be(true)
        end

        it 'returns true if value in argument is true for all elements' do
          result = [3, 3, 3].my_all?(3)
          expect(result).to be(true)
        end
      end
    end
  end

  describe '#my_any?' do
    it 'returns true if the block ever returns a value other than false or nil' do
      result = strings.my_any? { |word| word.length < 4 }
      expect(result).to_not be(true)
    end

    context 'when no block is given' do
      it 'returns true if at least one of the collection members is not false or nil' do
        result = [nil, true, 99].my_any?
        expect(result).to be(true)
      end

      context 'when argument is provided' do
        it 'returns whether pattern === element for any collection member if pattern is supplied' do
          result = %w[ant bear cat].my_any?(/t/)
          expect(result).to be(true)
        end

        it 'returns true if object type in argument is true for any element' do
          result = [1, 'a', { foo: 2 }].my_any?(Numeric)
          expect(result).to be(true)
        end

        it 'returns true if value in argument is true for any element' do
          result = [1, 2, 3].my_any?(4)
          expect(result).to_not be(true)
        end
      end
    end
  end

  describe '#my_none?' do
    it 'returns true if the block never returns true for all elements' do
      result = strings.my_none? { |word| word.length > 6 }
      expect(result).to be(true)
    end

    context 'when no block is given' do
      it 'returns true only if none of the collection members is true' do
        result = [nil, false].my_none?
        expect(result).to be(true)
      end

      context 'when argument is provided' do
        it 'returns whether pattern === element for none of the collection members if pattern is supplied' do
          result = %w[ant bear cat].my_none?(/d/)
          expect(result).to be(true)
        end

        it 'returns true if none of the collection members is equal to the object type in argument' do
          result = [1, 'a', { foo: 2 }].my_none?(Numeric)
          expect(result).to_not be(true)
        end

        it 'returns true if value in argument is true for any element' do
          result = strings.my_none?(4)
          expect(result).to be(true)
        end
      end
    end
  end

  describe '#my_count' do
    it 'counts and returns the number of elements yielding a true value' do
      result = strings.my_count { |name| name.length == 4 }
      expect(result).to eq(1)
    end

    context 'when block is not given' do
      it 'counts and returns the number of elements that are equal to item in argument if argument is given' do
        result = strings.my_count('john')
        expect(result).to eq(1)
      end

      it 'returns the number of elements in collection' do
        result = numbers.my_count
        expect(result).to eq(3)
      end

      it 'returns the number of elements in a range' do
        result = (1..9).my_count
        expect(result).to eq(9)
      end
    end

    context 'when a Proc is given as argument' do
      length_four = proc { |name| name.length == 4 }

      it 'counts and returns the number of elements yielding a true value to the block' do
        result = strings.my_count(&length_four)
        expect(result).to eq(1)
      end
    end
  end

  describe '#my_map' do
    it 'returns a new array with the results of running block once for every element in collection' do
      result = numbers.my_map { |num| num**2 }
      expect(result).to eq([1, 4, 9])
    end

    it 'returns enumerator if block is not given' do
      result = numbers.my_map
      expect(result).to be_instance_of(Enumerator)
    end

    context 'when Proc is given in argument' do
      upcase_proc = proc { |name| name.upcase }

      it 'returns a new array with the results of running block once for every element in collection' do
        result = strings.my_map(upcase_proc)
        expect(result).to eq(%w[JOHN DAVID PETER])
      end
    end

    context 'when a Proc and block are given' do
      upcase_proc = proc { |name| name.upcase }

      it 'returns a new array with the results of running Proc block once for every element in collection' do
        result = strings.my_map(upcase_proc) { |name| "Name: #{name}" }
        expect(result).to eq(%w[JOHN DAVID PETER])
      end
    end
  end

  describe '#my_inject' do
    context 'when a block is given' do
      it 'combines all elements of enumerator by applying binary operation specified by block' do
        result = numbers.my_inject { |sum, n| sum + n }
        expect(result).to eq(6)
      end

      it 'works with strings given in enumerator' do
        strings = %w[cat sheep bear]
        longest = strings.inject { |accu, word| accu.length > word.length ? accu : word }
        expect(longest).to eq('sheep')
      end

      context 'when an initial value is given in argument' do
        it 'it combines all elements of enumerator by applying binary operation specified by block' do
          result = numbers.my_inject(2) { |product, n| product * n }
          expect(result).to eq(12)
        end
      end
    end

    context 'when argument is given, but no block is given' do
      it 'if symbol names a method or operator, combines all elements of enumerator by applying binary operation' do
        result = numbers.my_inject(:*)
        expect(result).to eq(6)
      end

      it 'if initial value and symbol are given, combines all elements of enumerator by applying binary operation' do
        result = numbers.my_inject(2, :*)
        expect(result).to eq(12)
      end
    end

    context 'when no block or argument is given' do
      it 'raises a LocalJumpError exception' do
        expect { numbers.my_inject }.to raise_error(LocalJumpError)
      end
    end
  end
end

describe 'multiply_els' do
  it 'multiples all elements in array and returns product' do
    arr = [2, 4, 5]
    result = multiply_els(arr)
    expect(result).to eq(40)
  end
end
