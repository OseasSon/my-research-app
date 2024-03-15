class CreateThreadJob < ApplicationJob
  queue_as :default

  def perform(chat)
    response = client.threads.create
    thread_id = response["id"]
    chat.update!(thread_id: thread_id)
  end

  def client
    OpenAI::Client.new
  end
end
