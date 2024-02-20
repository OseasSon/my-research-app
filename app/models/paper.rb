class Paper < ApplicationRecord
  belongs_to :user
  has_one :chat
  has_one :analysis
  has_many :citations
  has_one_attached :pdf, dependent: :destroy

  validates :title, presence: true
  validates :pdf, presence: true
  #validates :author, presence: true
  #validates :published_year, presence: true
end
