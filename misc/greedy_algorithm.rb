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
    k = @number_resources
    1.upto(k) do |i|
      list_paths = @resulting_matrix.to_a
      remove_paths_with_i_resources!(list_paths, i)
      p 'lists'
      p list_paths
      sub_solution_one_resource(list_paths)
    end
  end

  def remove_paths_with_i_resources!(list_paths, i_resources)
    # remove empty paths
    list_paths.each { |paths| paths.reject!(&:empty?) }
    return if @dispatched_nodes.empty?

    list_paths.each do |paths|
      paths.each do |path|
        path.reject! { |x| (x & @dispatched_nodes).count == i_resources }
      end
      paths.reject!(&:empty?)
    end
  end

  def print_result
    puts 'Original Matrix'
    puts @my_custom_matrix.print_original_matrix
    puts "Dispatch nodes in: #{@dispatched_nodes}"
  end

  private

  def sub_solution_one_resource(matrix)
    array_matrix = matrix
    remove_paths_with_present_node!(array_matrix)
    return if array_matrix.all?(&:empty?)

    @dispatched_nodes << find_most_frequent_value(array_matrix)
    sub_solution_one_resource(matrix)
  end

  def remove_paths_with_present_node!(list_paths)
    # TODO : code duplication. Use blocks and "yield"
    list_paths.each do |paths|
      paths.each do |path|
        path.select! { |x| (x & @dispatched_nodes).count.zero? }
      end
      paths.reject!(&:empty?)
    end
  end

  def find_most_frequent_value(array_matrix)
    freq = array_matrix.flatten.each_with_object(Hash.new(0)) do |v, h|
      h[v] += 1
      h
    end
    max = freq.values.max
    top_finds = freq.select { |_, f| f == max }
    top_finds.keys.sample
  end
end

# Class initialization and calling
=begin
input_matrix = Matrix[
  [0, 1, 0, 0],
  [1, 0, 1, 1],
  [0, 1, 0, 1],
  [0, 1, 1, 0]
]
=end

input_matrix = Matrix[
  [0, 1, 1, 0, 1, 0, 0],
  [1, 0, 0, 1, 1, 1, 1],
  [1, 0, 0, 1, 1, 0, 1],
  [0, 1, 1, 0, 0, 0, 0],
  [1, 1, 1, 0, 0, 0, 1],
  [0, 1, 0, 0, 0, 0, 1],
  [0, 1, 1, 0, 1, 1, 0]
]
algorithm = GreedyAlgorithm.new(input_matrix,
                                path_length: 5,
                                number_resources: 2,
                                cycles: true)
algorithm.apply
algorithm.print_result
