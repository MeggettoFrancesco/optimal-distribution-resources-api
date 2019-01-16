class ExecuteAlgorithmWorker
  include Sidekiq::Worker

  def perform(algorithm_id, class_name)
    algorithm = class_name.constantize.find_by(id: algorithm_id)
    algorithm.send(:apply_algorithm)
    algorithm.save!
  end
end
