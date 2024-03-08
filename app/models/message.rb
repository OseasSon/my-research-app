class Message < ApplicationRecord
  belongs_to :chat

  validates :body, presence: true
  validates :sender, presence: true
  validates :uuid, presence: true
end
