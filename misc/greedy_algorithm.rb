require 'matrix'
require_relative 'custom_matrix'

require 'byebug'
require 'rubocop'

class GreedyAlgorithm
  def initialize(matrix, path_length: 5, number_resources: 1, cycles: false)
    @path_length = path_length
    @number_resources = number_resources
    @cycles = cycles

    @my_custom_matrix = CustomMatrix.new(matrix, cycles: @cycles)
    @resulting_matrix = @my_custom_matrix.power_set(@path_length)

    @dispatched_nodes = []
  end

  def apply
    array_matrix = @resulting_matrix.to_a
    remove_paths_with_present_node!(array_matrix)
    return if array_matrix.all? { |x| x.empty? }

    @dispatched_nodes << find_most_frequent_value(array_matrix)
    apply
  end

  def print_result
    puts "Original Matrix"
    puts @my_custom_matrix.print(@resulting_matrix)

    puts "Dispatch nodes in: #{@dispatched_nodes}"
  end

  private

  def remove_paths_with_present_node!(array_matrix)
    array_matrix = array_matrix.each do |a|
      a.reject! do |x|
        (x.first & @dispatched_nodes).count != 0 if x != []
      end
      a.reject!(&:empty?)
    end
    array_matrix
  end

  def find_most_frequent_value(array_matrix)
    freq = array_matrix.flatten.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
    max = freq.values.max
    top_finds = freq.select { |k, f| f == max }
    top_finds.keys.sample
  end
end

# Class initialization and calling
input_matrix = Matrix[
  [[], [true], [], []],
  [[true], [], [true], [true]],
  [[], [true], [], [true]],
  [[], [true], [true], []]
]
algorithm = GreedyAlgorithm.new(input_matrix,
                                path_length: 3,
                                number_resources: 1,
                                cycles: false)
algorithm.apply
algorithm.print_result
