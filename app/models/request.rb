class Request < ApplicationRecord
  extend Enumerize

  has_one :greedy_algorithm

  enumerize :request_type, in: %i[greedy_algorithm]

  validates :request_type, presence: true
end
