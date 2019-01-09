require 'matrix'

class Api::V1::GreedyAlgorithmsController < ApiController
  def index
    input_array = JSON.parse(params[:matrix])
    input_matrix = Matrix.rows(input_array)

    my_algorithm = GreedyAlgorithm.new(matrix: input_matrix,
                                       path_length: 3,
                                       number_resources: 1,
                                       cycles: false)
    response = my_algorithm.apply
    render json: { result: response }
  end
end
