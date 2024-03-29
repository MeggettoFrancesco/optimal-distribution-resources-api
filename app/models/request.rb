class Request < ApplicationRecord
  extend Enumerize

  has_one :greedy_algorithm

  enumerize :request_type, in: %i[greedy_algorithm]

  validates :request_type, presence: true

  before_create :set_uuid

  private

  # Changes of collision are extremely low
  def set_uuid
    self.id = SecureRandom.uuid
  end
end
