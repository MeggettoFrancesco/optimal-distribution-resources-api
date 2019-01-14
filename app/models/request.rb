class Request < ApplicationRecord
  extend Enumerize

  has_one :greedy_algorithm

  # TODO : add new request_type(s) here. Only greedy for now
  enumerize :request_type, in: %i[greedy_algorithm]
end
