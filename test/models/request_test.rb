require 'test_helper'
require 'models/_shared_models_test'

class RequestTest < ActiveSupport::TestCase
  include SharedModelsTest

  setup do
    @my_request = build(:request)
  end

  test 'should have a valid greedy_algorithm' do
    assert @my_request.greedy_algorithm.valid?
  end

  test 'should be invalid without request_type' do
    invalid_without(@my_request, :request_type)
  end

  test 'request_type should be in request_type.values' do
    assert Request.request_type.values.include?(@my_request.request_type)
  end

  test 'should have a well-formatted UUID after save' do
    @my_request.save!
    uuid_regex = /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-
                   [0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/x
    assert uuid_regex.match?(@my_request.id)
  end
end
