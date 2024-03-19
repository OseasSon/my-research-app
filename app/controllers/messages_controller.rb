class MessagesController < ApplicationController

  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.build(message_params.merge(sender: 'You'))

    respond_to do |format|
      if @message.save
        CreateMessageJob.perform_later(@message)
        format.turbo_stream do
          render turbo_stream: turbo_stream.append('messages', partial: 'messages/message', locals: { message: @message })
        end
        format.html { redirect_to @chat.paper }
      else
        # handle error
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :sender)
  end
end
