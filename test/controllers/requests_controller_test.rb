require 'test_helper'

class RequestsControllerTest < ActionDispatch::IntegrationTest
  test 'api_v1_requests#create should create a request' do
    my_request = build(:request)

    before_count = Request.count

    post api_v1_requests_path(
      request: obtain_my_request(my_request)
    )

    assert_equal 1, (Request.count - before_count)
    assert_response :success
  end

  test 'api_v1_requests#create should render errors if request
        in api_v1_requests#create is invalid' do
    my_request = build(:request)
    my_request.send(my_request.request_type).path_length = 0

    post api_v1_requests_path(
      request: obtain_my_request(my_request)
    )

    api_response = JSON.parse(response.body)
    api_response.except!('message')

    assert_equal expected_create_error_response, api_response
    assert_response :success
  end

  test 'should api_v1_request#show' do
    my_request = create(:request)
    get api_v1_request_path(id: my_request)
    assert_response :success
  end

  test 'should render error on api_v1_request#show if id not present' do
    get api_v1_request_path(id: 1)

    assert_equal expected_show_error_response, JSON.parse(response.body)
    assert_response :success
  end

  private

  def obtain_my_request(my_request)
    request_hash = {
      request_type: my_request.request_type,
      algorithm_parameters: {}
    }

    my_request.send(my_request.request_type).attributes.each do |key, value|
      request_hash[:algorithm_parameters][key] = value unless value.nil?
    end

    request_hash
  end

  def expected_create_error_response
    {
      'status' => 'error',
      'code' => 404
    }
  end

  def expected_show_error_response
    standard_error = expected_create_error_response
    standard_error['message'] = 'Request not found'
    standard_error
  end
end
