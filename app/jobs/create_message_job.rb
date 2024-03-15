class CreateMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    chat = message.chat

    response = client.messages.create(
      thread_id: chat.thread_id,
      parameters: {
        role: "user",
        content: message.body
      }
    )
    message_id = response["id"]
    chat.messages.last.update!(message_openai_id: message_id)

    paper = chat.paper
    bot_reply_body, bot_message_id = run_and_handle_response(chat.thread_id, paper.assistant_id)
    bot_reply = chat.messages.build(body: bot_reply_body, sender: "Assistant", message_openai_id: bot_message_id)

    if bot_reply.save
      Turbo::StreamsChannel.broadcast_append_to("stream_#{chat.id}",
        target: "messages",
        partial: "messages/reply",
        locals: { reply: bot_reply })
    else
      puts 'Error saving bot reply to the database'
      puts bot_reply.errors.full_messages.to_sentence
    end
  end

  private

  def client
    OpenAI::Client.new
  end

  def run_and_handle_response(thread_id, assistant_id)
    response = client.runs.create(thread_id: thread_id, parameters: { assistant_id: assistant_id })
    run_id = response['id']

    puts "🔵 run_response: #{response}"

    while true do
      response = client.runs.retrieve(id: run_id, thread_id: thread_id)
      status = response['status']

      puts "🔵 run_retrieve: #{response}"

      case status
      when 'queued', 'in_progress', 'cancelling'
        sleep 1
      when 'completed'
        return handle_completed_run(thread_id, run_id)
      when 'requires_action', 'cancelled', 'failed', 'expired'
        return "Error with the response: #{status}"
      else
        return "Unknown status response: #{status}"
      end
    end
  end

  def handle_completed_run(thread_id, run_id)
    bot_reply_body = nil

    run_steps = client.run_steps.list(thread_id: thread_id, run_id: run_id)

    puts "🔵 run_steps: #{run_steps}"

    new_message_ids = run_steps['data'].filter_map do |step|
      if step['type'] == 'message_creation'
        step.dig('step_details', "message_creation", "message_id")
      end
    end

    puts "🔵 new_message_ids: #{new_message_ids}"

    bot_message_id = new_message_ids.last
    last_message = client.messages.retrieve(id: bot_message_id, thread_id: thread_id)

    puts "🔵 last_message: #{last_message}"

    last_message['content'].each do |content_item|
      if content_item['type'] == 'text'
        bot_reply_body = content_item.dig('text', 'value')
      end
    end

    puts "🔵 bot_reply_body: #{bot_reply_body}"

    [bot_reply_body, bot_message_id]
  end
end
