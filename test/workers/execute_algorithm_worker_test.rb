require 'test_helper'
require 'sidekiq/testing'

class ExecuteAlgorithmWorkerTest < MiniTest::Test
  include FactoryBot::Syntax::Methods

  def setup
    Sidekiq::Worker.clear_all
    my_request = create(:request)
    @my_algorithm = my_request.send(my_request.request_type)
    @my_algorithm.compute_solution
  end

  def test_solution_is_updated
    ExecuteAlgorithmWorker.drain

    assert_equal 0, ExecuteAlgorithmWorker.jobs.size
    assert @my_algorithm.reload.solution
  end
end
