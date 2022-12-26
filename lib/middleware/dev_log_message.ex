defmodule MayhemChatbot.Middleware.DevLogMessage do
  use ExGram.Middleware

  require Logger

  def call(context, _opts) do
    Logger.debug("Received update: #{inspect(context)}")
    context
  end
end
