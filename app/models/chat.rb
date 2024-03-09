class Chat < ApplicationRecord
  belongs_to :paper
  has_many :messages, dependent: :destroy
end
