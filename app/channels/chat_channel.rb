# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  state_attr_accessor :workspace

  def subscribed
    self.workspace = Workspace.find_by(public_id: params[:id])
    return reject unless workspace

    stream_for workspace
  end

  def speak(data)
    message = data.fetch("message")

    broadcast_to(
      workspace,
      action: "newMessage",
      html: html("chats/message", message: message, name: user.name),
      author_id: user.id
    )
  end
end
