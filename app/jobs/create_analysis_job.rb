class CreateAnalysisJob < ApplicationJob
  queue_as :default

  def perform(analysis)
    prompt = "Please give me a brief analysis of the paper of a maximum 300 words answering the following questions: "\
             "1-What is the main point of the paper?, "\
             "2-What are the main findings of the paper?, "\
             "3-What are the main contributions of the paper?, "\
             "4-What are the main limitations of the paper?. "\
             "Make sure to separate each question in separate paragraphs, and for each paragraph make sure to include the Question as heading."

    response = client.messages.create(
      thread_id: analysis.thread_id,
      parameters: {
        role: "user",
        content: prompt
      }
    )

    summary_id = response["id"]
    puts "🟡 analysis.paper.assistant_id: #{analysis.paper.assistant_id}"
    summary_response_body = run_and_handle_response(analysis.thread_id, analysis.paper.assistant_id)
    puts "🟡 summary_response_body: #{summary_response_body}"

    # Assuming the response is a string with each summary separated by two newlines
    summaries = summary_response_body.split("\n\n")

    analysis.update(
      summary_1: summaries[1],
      summary_2: summaries[3],
      summary_3: summaries[5],
      summary_4: summaries[7]
    )
  end

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
    summary_response_body = nil

    run_steps = client.run_steps.list(thread_id: thread_id, run_id: run_id)

    puts "🔵 run_steps: #{run_steps}"

    new_message_ids = run_steps['data'].filter_map do |step|
      if step['type'] == 'message_creation'
        step.dig('step_details', "message_creation", "message_id")
      end
    end

    summary_response_id = new_message_ids.last
    last_message = client.messages.retrieve(id: summary_response_id, thread_id: thread_id)

    puts "🔵 last_message: #{last_message}"

    last_message['content'].each do |content_item|
      if content_item['type'] == 'text'
        summary_response_body = content_item.dig('text', 'value')
      end
    end

    puts "🔵 summary_response_body: #{summary_response_body}"

    summary_response_body
  end
end
