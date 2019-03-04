FactoryBot.define do
  factory :greedy_algorithm do
    input_matrix { create_matrix }
    path_length { [3, 4].sample }
    number_resources { [1, 2].sample }
    cycles { Faker::Boolean.boolean }
  end
end

private

def create_matrix
  size = rand(4..7)

  Array.new(size) do |row|
    Array.new(size) do |col|
      if row == col
        0
      else
        [0, 1].sample
      end
    end
  end
end
