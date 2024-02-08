class Graph < ApplicationRecord
  belongs_to :citation
  belongs_to :paper
end
