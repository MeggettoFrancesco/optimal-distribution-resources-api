require 'test_helper'
require 'sidekiq/testing'
require 'models/_shared_models_test'

class GreedyAlgorithmTest < ActiveSupport::TestCase
  include SharedModelsTest

  setup do
    @greedy_algorithm = build(:request).greedy_algorithm
  end

  test 'should have a valid request' do
    assert @greedy_algorithm.request.valid?
  end

  test 'should be invalid without input_matrix' do
    invalid_without(@greedy_algorithm, :input_matrix)
  end

  test 'should be invalid without number_resources' do
    invalid_without(@greedy_algorithm, :number_resources)
  end

  test 'valid only with number_resources less than path_length' do
    assert_path_length_n_resources_values(3, 4, :invalid?)
    assert_path_length_n_resources_values(3, 3, :invalid?)
    assert_path_length_n_resources_values(4, 3, :valid?)
  end

  test 'invalid with path_length less or equal to 0' do
    assert_individual_attribute_update(:path_length, 0, :invalid?)
    assert_individual_attribute_update(:path_length, -1, :invalid?)
  end

  test 'valid with number_resources greater or equal to 1' do
    assert_individual_attribute_update(:number_resources, 1, :valid?)
    assert_individual_attribute_update(:number_resources, 0, :invalid?)
    assert_individual_attribute_update(:number_resources, 2, :valid?)
  end

  test 'should be invalid without cycles' do
    invalid_without(@greedy_algorithm, :cycles)
  end

  test 'compute_solution should create a ExecuteAlgorithmWorker job' do
    Sidekiq::Worker.clear_all
    @greedy_algorithm.compute_solution
    assert_equal 1, ExecuteAlgorithmWorker.jobs.size
  end

  private

  def assert_path_length_n_resources_values(path_length, n_resources, assertion)
    @greedy_algorithm.path_length = path_length
    @greedy_algorithm.number_resources = n_resources
    assert @greedy_algorithm.send(assertion)
  end

  def assert_individual_attribute_update(attribute, value, assertion)
    @greedy_algorithm.send("#{attribute}=", value)
    assert @greedy_algorithm.send(assertion)
  end
end
