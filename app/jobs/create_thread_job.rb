class CreateThreadJob < ApplicationJob
  queue_as :default

  def perform(chat=nil, analysis=nil)
    response = client.threads.create
    thread_id = response["id"]

    if chat
      chat.update!(thread_id: thread_id)
    elsif analysis
      analysis.update!(thread_id: thread_id)
      CreateAnalysisJob.perform_later(analysis)
    end
  end

  def client
    OpenAI::Client.new
  end
end
