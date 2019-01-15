class Api::V1::RequestsController < ApiController
  def index
    my_params = request_params
    request_type = my_params[:request_type]
    algorithm_class = request_type.classify.constantize

    my_algorithm = algorithm_class.new(my_params[:algorithm_parameters])
    my_algorithm.request = Request.new(
      request_type: request_type,
      ip_address: request.remote_ip
    )

    save_and_render(my_algorithm)
  end

  private

  def save_and_render(my_algorithm)
    if my_algorithm.save
      render json: { result: my_algorithm.solution }
    else
      render json: { status: 'error', code: 400, message: my_algorithm.errors }
    end
  end

  def request_params
    # TODO : provide default values
    parameters = params.require(:request)
                       .permit(:request_type,
                               algorithm_parameters: algorithm_parameters)
    input_matrix = parameters[:algorithm_parameters][:input_matrix]
    parameters[:algorithm_parameters][:input_matrix] = JSON.parse(input_matrix)
    parameters
  end

  def algorithm_parameters
    %i[path_length number_resources cycles input_matrix]
  end
end
