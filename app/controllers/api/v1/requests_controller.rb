class Api::V1::RequestsController < ApiController
  # TODO : test and fix when json doesn't include request for example
  def index
    my_params = request_params
    my_request = create_request(my_params)
    return render json: json_error(my_request.errors) if my_request.invalid?

    algorithm_class = my_request.request_type.classify.constantize
    my_algorithm = algorithm_class.new(my_params[:algorithm_parameters])
    my_algorithm.request = my_request

    save_and_render(my_algorithm)
  end

  private

  def create_request(my_params)
    request_type = my_params[:request_type]
    my_request = Request.new(
      request_type: request_type,
      ip_address: request.remote_ip
    )
    my_request
  end

  def save_and_render(my_algorithm)
    if my_algorithm.save
      render json: { result: my_algorithm.solution }
    else
      render json: json_error(my_algorithm.errors)
    end
  end

  def json_error(message)
    { status: 'error', code: 400, message: message }
  end

  def request_params
    # TODO : provide default values
    parameters = params.require(:request)
                       .permit(:request_type,
                               algorithm_parameters: algorithm_parameters)
    parse_input_matrix!(parameters)
    parameters
  end

  def parse_input_matrix!(parameters)
    input_matrix = parameters[:algorithm_parameters][:input_matrix]
    return unless input_matrix.present?

    parameters[:algorithm_parameters][:input_matrix] = JSON.parse(input_matrix)
  end

  def algorithm_parameters
    %i[path_length number_resources cycles input_matrix]
  end
end
