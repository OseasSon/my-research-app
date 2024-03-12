class RequestJob < ApplicationJob
  queue_as :default

  def perform(message_params, chat, api_key)
    connection = Faraday.new(url: 'https://api.openai.com')

    response = connection.post do |req|
      req.url "/v1/chat/completions"
      req.headers['Content-Type'] = "application/json"
      req.headers['Authorization'] = "Bearer #{api_key}"
      req.body = {
        model: "gpt-3.5-turbo",
        messages: [
          {
            "role": "system",
            "content": "You're a helpful (but still funny) assistant."
          },
          {
            "role": "user",
            "content": message_params[:body]
          }
        ],
        max_tokens: 250,
        temperature: 0.5
      }.to_json
    end

    puts response.inspect

    json_response = JSON.parse(response.body)
    parsed_reply = json_response['choices'][0]['message']['content']

    # Create a new message with the sender as "bot" and the content as the response text
    bot_reply = chat.messages.build(body: parsed_reply, sender: 'Assistant')

    puts bot_reply.inspect

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
end
