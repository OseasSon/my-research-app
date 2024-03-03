OpenAI.configure do |config|
  config.access_token = ENV.fetch(:opanai, :access_token)
  config.request_timeout = 240
end
