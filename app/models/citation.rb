class Citation < ApplicationRecord
  belongs_to :paper
  belongs_to :graph

  validates :title, :author, :published_year, :citations_count, presence: true
  validates :published_year, :citations_count, numericality: { only_integer: true }
end
