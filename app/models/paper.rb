class Paper < ApplicationRecord
  belongs_to :user
  has_one :chat, dependent: :destroy
  has_one :analysis, dependent: :destroy
  has_many :citations, dependent: :destroy
  has_one_attached :pdf, dependent: :destroy

  validates :pdf, presence: true
  validate :pdf_file_validation
  validates :title, presence: true
  validates :author, presence: true

  after_commit :create_openai_assistant_and_analysis, on: :create

  private

  def create_openai_assistant_and_analysis
    CreateAssistantJob.perform_now(self)

    #After an assitant is created it also creates an analysis object
    create_analysis
  end

  def pdf_file_validation
    Rails.logger.info "🟢 Starting model validation..."
    errors.add(:pdf, "can't be blank") unless pdf.attached?

    if pdf.attached?
      unless pdf.content_type.in?(%w(application/pdf))
        errors.add(:pdf, 'File must be a PDF')
      end

      if pdf.blob.byte_size > 5.megabytes
        errors.add(:pdf, 'File size must be less than 5MB')
      end
    end
  end

  def create_analysis
    Analysis.create(paper: self)
  end

end
