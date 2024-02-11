class Analysis < ApplicationRecord
  belongs_to :paper

  validates :summary_1, :summary_2, :summary_3, :summary_4, presence: true
end
