class DeleteAssistantJob < ApplicationJob
  queue_as :default

  def perform(assistant_id, file_id)
    delete_assistant(assistant_id)
    delete_file(file_id)
  end

  private

  def delete_assistant(assistant_id)
    client.assistants.delete(id: assistant_id)
  end

  def delete_file(file_id)
    client.files.delete(id: file_id)
  end

  def client
    OpenAI::Client.new
  end
end
