class Api::V1::RequestsController < ApiController
  def index
    my_algorithm = GreedyAlgorithm.new(request_params)

    render json: { result: my_algorithm.solution } if my_algorithm.save
  end

  private

  def request_params
    # default_params = { greedy_algorithm: { :path_length: 5,
    #                    number_resources: 1, cycles: false }}
    # params.require(:request)
    #       .permit(:input_matrix, :path_length, :number_resources, :cycles)
    #       .merge(default_params)
    request = Request.create(request_type: :greedy_algorithm)

    { input_matrix: [[0, 1, 0, 0], [1, 0, 1, 1], [0, 1, 0, 1], [0, 1, 1, 0]],
      path_length: 3, number_resources: 1, cycles: false,
      request_id: request.id }
  end
end
