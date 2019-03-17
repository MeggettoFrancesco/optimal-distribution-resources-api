require 'benchmark'
require 'matrix'
require_relative 'greedy_algorithm'

Benchmark.bm do |benchmark|
  20.times do
    size = rand(10..100)
    input_matrix = Matrix.build(size) do |row, col|
      row == col ? 0 : [0, 1].sample
    end

    benchmark.report("Size #{size}") do
      algorithm = GreedyAlgorithm.new(input_matrix,
          path_length: 3,
          number_resources: 1,
          cycles: false)
        algorithm.apply
    end
  end
end
