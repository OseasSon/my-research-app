class Paper < ApplicationRecord
  belongs_to :user
  belongs_to :chat
  belongs_to :citation
end
