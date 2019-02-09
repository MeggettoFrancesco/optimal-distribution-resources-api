class Api::V1::RequestsController < ApiController
  # TODO : test and fix when json doesn't include request for example
  def create
    my_params = request_params
    my_request = create_request(my_params)
    return render json: json_error(my_request.errors) if my_request.invalid?

    algorithm_class = my_request.request_type.classify.constantize
    my_algorithm = algorithm_class.new(my_params[:algorithm_parameters])
    my_algorithm.request = my_request

    save_and_render(my_algorithm)
  end

  def show
    my_request = Request.find_by(id: params[:id])

    if my_request.present?
      solution = my_request.send(my_request.request_type).solution
      answer = solution.nil? ? "I'm still computing..." : solution
      render json: json_ok(:result, answer)
    else
      render json: json_error('request not found')
    end
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
      my_algorithm.compute_solution
      render json: json_ok(:request_uuid, my_algorithm.request.id)
    else
      render json: json_error(my_algorithm.errors)
    end
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

  def json_ok(attribute, message)
    { status: 'ok', code: 200, attribute => message }
  end

  def json_error(message)
    { status: 'error', code: 404, message: message }
  end

  def algorithm_parameters
    %i[path_length number_resources cycles input_matrix]
  end
end
