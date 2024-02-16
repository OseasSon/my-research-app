class Paper < ApplicationRecord
  belongs_to :user
  has_one :chat
  has_one :analysis
  has_many :citations

  validates :title, presence: true
  #validates :author, presence: true
  #validates :published_year, presence: true
end
