class Graph < ApplicationRecord
  belongs_to :paper
  has_many :citations
end
