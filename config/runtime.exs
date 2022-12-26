import Config

if Config.config_env() == :dev do
  DotenvParser.load_file(".env")
end

chats_allowlist =
  System.get_env("CHATS_ALLOWLIST", "")
  |> String.split(",")

config :mayhem_chatbot,
  bot_token: System.fetch_env!("BOT_TOKEN"),
  chats_allowlist: chats_allowlist

config :openai,
  api_key: System.fetch_env!("OPENAI_API_KEY")
