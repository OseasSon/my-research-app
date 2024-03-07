class MessagesController < ApplicationController
  def index
  end

  def show
  end

  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.build(message_params.merge(sender: 'user'))

    if @message.save
      response = OpenAI.create_completion(
        model: "gpt-3.5-turbo",
        prompt: @message.body,
        max_tokens: 60
      )

      # response = OpenAI.chat(
      #   parameters: {
      #   model: "gpt-3.5-turbo", # Required.
      #   messages: [{ role: "user", content: @message.body}], # Required.
      #   temperature: 0.7,
      # })

      @reply = @chat.messages.build(body: response.choices.first.text.strip, sender: 'bot')
      @reply.save
    end

    redirect_to @chat.paper
  end

  private

  def message_params
    params.require(:message).permit(:body, :sender)
  end
end
