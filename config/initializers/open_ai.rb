OpenAI.configure do |config|
  api_key = Rails.application.credentials.openai[:api_key]
  config.access_token = api_key
  config.request_timeout = 240
end
