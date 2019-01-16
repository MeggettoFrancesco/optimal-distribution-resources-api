require 'matrix'

class GreedyAlgorithm < ApplicationRecord
  belongs_to :request

  serialize :input_matrix
  serialize :solution

  validates :input_matrix, presence: true
  validates :path_length, presence: true,
                          numericality: { greater_than_or_equal_to: 1 }
  validates :number_resources, presence: true,
                               numericality: { greater_than_or_equal_to: 1 }
  validates :cycles, inclusion: { in: [true, false] }

  def compute_solution
    ExecuteAlgorithmWorker.perform_async(id, self.class)
  end

  private

  def apply_algorithm
    create_resulting_matrix
    self.solution = []
    list_paths = retrieve_paths
    # add first K most frequent nodes in @solution
    s_nodes = find_most_frequent_nodes(list_paths, number_resources)
    solution.concat(s_nodes)

    until list_paths.empty?
      remove_paths!(list_paths)
      node = find_most_frequent_nodes(list_paths, 1)
      solution.concat(node) if node.present?
    end
  end

  def create_resulting_matrix
    matrix_object = Matrix.rows(input_matrix)
    @my_custom_matrix = CustomMatrix.new(matrix_object, cycles: cycles)
    @resulting_matrix = @my_custom_matrix.power_set(path_length)
  end

  def retrieve_paths
    list_paths = @resulting_matrix.to_a
    # remove empty paths
    list_paths.each { |paths| paths.reject!(&:empty?) }
  end

  def remove_paths!(list_paths)
    # remove paths in L containing K vertices in solution as well as removing
    # empty paths. This will speed up the process in the long run
    new_paths = list_paths.each do |paths|
      paths.each do |path|
        path.reject! { |x| (x & solution).count == number_resources }
      end
      paths.reject!(&:empty?)
    end
    new_paths.reject!(&:empty?)
  end

  def find_most_frequent_nodes(list_paths, n_resources)
    frequencies = frequency_hash(list_paths)
    top_vals = frequencies.values.max_by(n_resources) { |i| i }
    most_frequent_nodes(frequencies, top_vals)
  end

  def frequency_hash(list_paths)
    list_paths.flatten.each_with_object(Hash.new(0)) do |val, hash|
      hash[val] += 1
      hash
    end
  end

  def most_frequent_nodes(frequencies, top_values)
    most_frequent_nodes = []
    top_values.each do |value|
      top_finds = frequencies.select { |_, frequency| frequency == value }
      most_frequent_nodes << top_finds.keys.first
    end
    most_frequent_nodes
  end
end
