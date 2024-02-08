class Chat < ApplicationRecord
  belongs_to :paper
  belongs_to :message
end
