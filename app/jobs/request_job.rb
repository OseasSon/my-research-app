class RequestJob < ApplicationJob
  queue_as :default

  def perform(message_params, api_key)
    connection = Faraday.new(url: 'https://api.openai.com')

    response = connection.post do |req|
      req.url "/v1/chat/completions"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{api_key}"
      req.body = {
        model: 'gpt-3.5-turbo',
        messages: [
          {
            "role": "system",
            "content": "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair."
          },
          {
            "role": "user",
            "content": message_params[:body]
          }
        ],
        max_tokens: 250,
        temperature: 0.5,
        n: 1
      }.to_json
    end

    puts response.inspect

    # json_response = JSON.parse(response.body)
    # generated_idea = json_response['choices'][0]['text']
  end
end
