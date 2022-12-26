defmodule MayhemChatbot do
  require Logger

  @bot :mayhem_chatbot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  def bot(), do: @bot
  def me(), do: ExGram.get_me(bot: bot())
end
