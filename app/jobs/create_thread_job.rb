class CreateThreadJob < ApplicationJob
  queue_as :default

  def perform(paper)
    response = client.threads.create
    thread_id = response["id"]
    paper.chat.update!(thread_id: thread_id)
  end

  def client
    OpenAI::Client.new
  end
end
