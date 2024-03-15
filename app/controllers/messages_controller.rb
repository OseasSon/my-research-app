class MessagesController < ApplicationController
  before_action :get_api_key, only: [:create]

  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.build(message_params.merge(sender: 'You'))

    if @message.save
      # RequestJob.perform_later(message_params, @chat, @api_key)
      CreateMessageJob.perform_later(@message)
      redirect_to @chat.paper
    else
      # Handle the error here.
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :sender)
  end

  def get_api_key
    @api_key = Rails.application.credentials.openai[:api_key]
  end
end
