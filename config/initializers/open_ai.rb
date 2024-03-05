OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.openai_access_token
  config.request_timeout = 240
end
