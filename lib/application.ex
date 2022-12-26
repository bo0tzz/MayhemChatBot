defmodule MayhemChatbot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("Starting Mayhem Chatbot")

    children = [
      ExGram,
      {MayhemChatbot,
       [method: :polling, token: Application.fetch_env!(:mayhem_chatbot, :bot_token)]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MayhemChatbot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
