class Analysis < ApplicationRecord
  belongs_to :paper, dependent: :destroy

  after_create :create_thread_and_analysis_job

  private

  def create_thread_and_analysis_job
    # The analysis job is called from within the thread job
    CreateThreadJob.perform_later(nil, self)
  end
end
