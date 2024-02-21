class Paper < ApplicationRecord
  belongs_to :user
  has_one :chat
  has_one :analysis
  has_many :citations
  has_one_attached :pdf, dependent: :destroy

  validates :pdf, presence: true
  validate :pdf_file_validation
  validates :title, presence: true
  #validates :author, presence: true
  #validates :published_year, presence: true

  private

  def pdf_file_validation
    if pdf.attached?
      unless pdf.content_type.in?(%w(application/pdf))
        errors.add(:pdf, 'File must be a PDF')
      end

      if pdf.blob.byte_size > 5.megabytes
        errors.add(:pdf, 'File size must be less than 5MB')
      end
    end
  end

end
