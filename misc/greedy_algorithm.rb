require 'matrix'
require_relative 'custom_matrix'

class GreedyAlgorithm
  def initialize(matrix, path_length: 3, number_resources: 1, cycles: false)
    @path_length = path_length
    @number_resources = number_resources
    @cycles = cycles
    @my_custom_matrix = CustomMatrix.new(matrix, cycles: @cycles)
    @resulting_matrix = @my_custom_matrix.power_set(@path_length)
    @solution = []
  end

  def apply
    list_paths = retrieve_paths
    # add first K most frequent nodes in @solution
    s_nodes = find_most_frequent_nodes(list_paths, @number_resources)
    @solution.concat(s_nodes)

    until list_paths.empty?
      remove_paths!(list_paths)
      node = find_most_frequent_nodes(list_paths, 1)
      @solution.concat(node) unless node.nil?
    end
  end

  def print_result
    puts 'Original Matrix'
    puts @my_custom_matrix.print_original_matrix
    puts "Dispatch nodes in: #{@solution}"
  end

  private

  def retrieve_paths
    list_paths = @resulting_matrix.to_a
    # remove empty paths
    list_paths.each { |paths| paths.reject!(&:empty?) }
  end

  def remove_paths!(list_paths)
    # remove paths in L containing K vertices in @solution as well as removing
    # empty paths. This will speed up the process in the long run
    new_paths = list_paths.each do |paths|
      paths.each do |path|
        path.reject! { |x| (x & @solution).count == @number_resources }
      end
      paths.reject!(&:empty?)
    end
    new_paths.reject!(&:empty?)
  end

  def find_most_frequent_nodes(list_paths, n_resources)
    return if list_paths.empty?

    frequencies = frequency_hash(list_paths)
    return if frequencies.empty?

    top_vals = []
    (1..n_resources).each do
      top_vals << frequencies.max_by { |_, v| v }[0]
      frequencies.reject! { |k, _| top_vals.include?(k) }
    end

    top_vals
  end

  def frequency_hash(list_paths)
    without_solution = list_paths.flatten - @solution
    without_solution.each_with_object(Hash.new(0)) do |val, hash|
      hash[val] += 1
      hash
    end
  end
end

# Class initialization and calling
# input_matrix = Matrix[
#   [0, 1, 0, 0],
#   [1, 0, 1, 1],
#   [0, 1, 0, 1],
#   [0, 1, 1, 0]
# ]

# First case
# first_input_matrix = Matrix[
#   [0, 1, 1, 0, 0, 0],
#   [1, 0, 0, 1, 0, 0],
#   [1, 0, 0, 1, 1, 0],
#   [0, 1, 1, 0, 0, 1],
#   [0, 0, 1, 0, 0, 1],
#   [0, 0, 0, 1, 1, 0]
# ]

# Second case
# second_input_matrix = Matrix[
#   [0, 1, 1, 0, 0],
#   [1, 0, 0, 1, 0],
#   [1, 0, 0, 1, 1],
#   [0, 1, 1, 0, 0],
#   [0, 0, 1, 0, 0]
# ]

# Third case
third_input_matrix = Matrix[
  [0, 1, 1, 0, 0, 0, 0, 0],
  [1, 0, 0, 1, 0, 0, 0, 0],
  [1, 0, 0, 1, 1, 0, 0, 0],
  [0, 1, 1, 0, 0, 1, 0, 0],
  [0, 0, 1, 0, 0, 1, 1, 0],
  [0, 0, 0, 1, 1, 0, 0, 1],
  [0, 0, 0, 0, 1, 0, 0, 1],
  [0, 0, 0, 0, 0, 1, 1, 0]
]

# Fourth case
# fourth_input_matrix = Matrix[
#   [0, 1, 0, 1, 0, 0, 0],
#   [1, 0, 1, 1, 0, 0, 0],
#   [0, 1, 0, 0, 0, 0, 1],
#   [1, 1, 0, 0, 0, 0, 0],
#   [0, 0, 0, 0, 0, 1, 0],
#   [0, 1, 0, 0, 1, 0, 1],
#   [0, 0, 1, 0, 0, 1, 0]
# ]

# number_resources should bw < than path_length
algorithm = GreedyAlgorithm.new(third_input_matrix,
                                path_length: 3,
                                number_resources: 2,
                                cycles: true)
algorithm.apply
algorithm.print_result
