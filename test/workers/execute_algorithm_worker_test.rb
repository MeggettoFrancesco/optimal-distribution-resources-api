require 'test_helper'
require 'sidekiq/testing'

class ExecuteAlgorithmWorkerTest < MiniTest::Test
  include FactoryBot::Syntax::Methods

  def setup
    Sidekiq::Worker.clear_all
    @my_greedy_algorithm = create(:request).greedy_algorithm
    @my_greedy_algorithm.compute_solution
  end

  def test_solution_is_updated
    ExecuteAlgorithmWorker.drain

    assert_equal 0, ExecuteAlgorithmWorker.jobs.size
    assert @my_greedy_algorithm.reload.solution
  end
end
