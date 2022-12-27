defmodule MayhemChatbot.Middleware.Allowlist do
  use ExGram.Middleware

  alias ExGram.Cnt
  require Logger

  def call(
        %Cnt{update: %{message: %{chat: %{id: chat_id}}}} = context,
        _opts
      ) do
    allowed = Application.fetch_env!(:mayhem_chatbot, :chats_allowlist)
    Logger.debug("Testing message from chat #{chat_id} against allowlist #{inspect(allowed)}")

    case chat_id in allowed do
      true ->
        context

      false ->
        Logger.info("Ignoring message from non-allowed chat #{chat_id}")
        %{context | halted: true}
    end
  end

  def call(cnt, _opts), do: cnt
end
