class CreateAssistantJob < ApplicationJob
  queue_as :default

  def perform(paper)
    file_id = upload_file(paper.pdf.blob)

    response = client.assistants.create(
      parameters: {
        model: "gpt-3.5-turbo-0125",
        name: "Assistant for paper_id #{paper.id}",
        instructions: "You're a helpful assistant that will reply to question using your internal knowledge.",
        tools: [{ type: 'retrieval' }],
        "file_ids": [file_id]
      }
    )
    assistant_id = response["id"]

    paper.update!(assistant_id:  assistant_id, file_id: file_id)
    puts "✅ Assistant created!"
  end

  def upload_file(blob)
    blob.open do |file|
      response = client.files.upload(
        parameters: {
          file: file.path,
          purpose: "assistants"
        }
      )
      response["id"]
    end
  end

  def client
    OpenAI::Client.new
  end
end
