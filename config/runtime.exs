import Config

if Config.config_env() == :dev do
  DotenvParser.load_file(".env")
end

chats_allowlist =
  System.get_env("CHATS_ALLOWLIST", "")
  |> String.split(",")
  |> Enum.reject(&(String.length(&1) == 0))
  |> Enum.map(&String.to_integer/1)

config :mayhem_chatbot,
  bot_token: System.fetch_env!("BOT_TOKEN"),
  chats_allowlist: chats_allowlist,
  gpt3_max_tokens: System.get_env("GPT3_MAX_TOKENS", "40") |> String.to_integer()

config :openai,
  api_key: System.fetch_env!("OPENAI_API_KEY")
