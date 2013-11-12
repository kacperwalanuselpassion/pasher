class ChatMessagesController < ApplicationController
  respond_to :json

  def index
    @chat_messages = Storage::ChatMessage.last
    respond_with @chat_messages, root: false
  end

  def create
    @chat_message = ChatMessageManager.new(current_user).save({'text' => params[:text]})
    respond_with @chat_message
  end

  def update
    @chat_message = Storage::ChatMessage.find(params[:id])
    @chat_message.update_attributes(params[:chat_message])

    Storage::ChatMessage.update(@chat_message)
    head :no_content
  end

  def destroy
    ChatMessageManager.new(current_user).remove(params[:id])
    head :no_content
  end
end
