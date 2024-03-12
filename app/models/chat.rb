class Chat < ApplicationRecord
  belongs_to :paper
  has_many :messages, dependent: :destroy

  after_create :create_thread

  private

  def create_thread
    CreateThreadJob.perform_later(self.paper)
  end
end
