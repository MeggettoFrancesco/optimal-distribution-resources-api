require 'matrix'

class CustomMatrix
  def initialize(matrix)
    @original = matrix
    @row_count = @original.row_count
    @column_count = @original.column_count
  end

  def print(matrix)
    puts matrix.to_a.map(&:inspect)
  end

  def power_set(power)
    return Matrix.build(@row_count, @column_count) { [] } if power == 1

    (2..power).each { |n| @multiply_matrix = multiplication(n) }
    @multiply_matrix
  end

  private

  # https://github.com/ruby/matrix/blob/master/lib/matrix.rb#L893
  def multiplication(power_number)
    rows = Array.new(@row_count) do |i|
      Array.new(@column_count) do |j|
        (0...@column_count).inject([]) do |vij, k|
          method_name = power_number == 2 ? 'second' : 'other'
          send("compute_#{method_name}_power", i, j, k, vij)
        end
      end
    end

    Matrix.rows(rows)
  end

  def compute_second_power(index_i, index_j, index_k, vij)
    if @original[index_k, index_j].zero? || @original[index_i, index_k].zero?
      vij.concat([])
    else
      vij.concat([index_k + 1])
    end
  end

  def compute_other_power(index_i, index_j, index_k, vij)
    multiply_matrix_values = @multiply_matrix[index_i, index_k]
    if @original[index_k, index_j].zero? || multiply_matrix_values.empty?
      vij.concat([])
    else
      vij.concat(multiply_matrix_values.map { |i| [i].flatten + [index_k + 1] })
    end
  end
end

# Class initialization and calling
input_matrix = Matrix[
  [0, 1, 0, 0],
  [1, 0, 1, 1],
  [0, 1, 0, 1],
  [0, 1, 1, 0]
]

my_custom_matrix = CustomMatrix.new(input_matrix)
resulting_matrix = my_custom_matrix.power_set(3)
puts '*** Result ***'
my_custom_matrix.print(resulting_matrix)
