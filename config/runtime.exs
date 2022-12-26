import Config

if Config.config_env() == :dev do
  DotenvParser.load_file(".env")
end

chats_allowlist =
  System.get_env("CHATS_ALLOWLIST", "")
  |> String.split(",")

config :image_bot,
  bot_token: System.fetch_env!("BOT_TOKEN"),
  chats_allowlist: chats_allowlist
