require 'matrix'

class CustomMatrix
  def initialize(matrix, cycles: false)
    @original = matrix
    @row_count = @original.row_count
    @column_count = @original.column_count
    @multiply_matrix = @original
    @cycles = cycles
  end

  def print(matrix)
    puts matrix.to_a.map(&:inspect)
  end

  def power_set(power)
    return Matrix.build(@row_count, @column_count) { [] } if power == 1

    (2..power).each { @multiply_matrix = multiplication }
    @multiply_matrix
  end

  private

  # https://github.com/ruby/matrix/blob/master/lib/matrix.rb#L893
  def multiplication
    rows = Array.new(@row_count) do |i|
      Array.new(@column_count) do |j|
        item = (0...@column_count).inject([]) do |vij, k|
          compute_power(i, j, k, vij)
        end
        item = remove_potential_cycles(item, i, j) unless @cycles
        item
      end
    end

    Matrix.rows(rows)
  end

  def compute_power(index_i, index_j, index_k, vij)
    multiply_matrix_values = @multiply_matrix[index_i, index_k]
    val = if @original[index_k, index_j] == [] || multiply_matrix_values.empty?
            []
          elsif multiply_matrix_values == [true]
            [[index_k + 1]]
          else
            multiply_matrix_values.map { |i| i + [index_k + 1] }
          end
    vij.concat(val)
  end

  def remove_potential_cycles(item, index_i, index_j)
    item.each do |value|
      item = [] if value.include?(index_i + 1) || value.include?(index_j + 1)
    end
    item
  end
end

# Class initialization and calling
input_matrix = Matrix[
  [[], [true], [], []],
  [[true], [], [true], [true]],
  [[], [true], [], [true]],
  [[], [true], [true], []]
]

my_custom_matrix = CustomMatrix.new(input_matrix)
resulting_matrix = my_custom_matrix.power_set(3)
puts '*** Result ***'
my_custom_matrix.print(resulting_matrix)