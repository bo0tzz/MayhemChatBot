defmodule MayhemChatbot do
  require Logger

  @bot :mayhemchatbot
  @preprompt "You are a chatbot called @mayhemchatbot. Continue the conversation below:\n"

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  middleware(MayhemChatbot.Middleware.DevLogMessage)
  middleware(MayhemChatbot.Middleware.Allowlist)
  middleware(ExGram.Middleware.IgnoreUsername)

  def handle({:text, "@mayhemchatbot " <> text, %{from: user} = msg}, context) do
    Logger.info("Got tagged")

    handle = get_user_handle(user)

    prompt = """
    @#{handle}: #{text}
    @mayhemchatbot:
    """

    reply(prompt, msg, context)
  end

  def handle({:text, text, msg}, context) do
    case msg do
      %{
        from: user,
        reply_to_message: %{from: %{username: "mayhemchatbot"}, text: reply_text}
      } ->
        Logger.info("Got reply chain message")

        handle = get_user_handle(user)

        prompt = """
        @mayhemchatbot: #{reply_text}
        @#{handle}: #{text}
        @mayhemchatbot:
        """

        reply(prompt, msg, context)

      _ ->
        Logger.debug("Ignoring message")
    end
  end

  def reply(prompt, msg, context) do
    # prompt = @preprompt <> prompt
    Logger.info("Generating reply to prompt: #{prompt}")

    response =
      case OpenAI.completions("davinci",
             prompt: prompt,
             max_tokens: Application.fetch_env!(:mayhem_chatbot, :gpt3_max_tokens)
           ) do
        {:ok, %{choices: [%{"text" => r}]}} -> r
        {:error, %{"error" => %{"message" => m}}} -> m
      end

    Logger.debug("Got reply: #{response}")

    # GPT likes to pretend to be you...
    # response = response |> String.split("\n@") |> List.first()

    answer(
      context,
      response,
      reply_to_message_id: msg.message_id
    )
  end

  defp get_user_handle(%{username: username}), do: "@" <> username

  defp get_user_handle(%{first_name: first_name, last_name: last_name}),
    do: "@#{first_name} #{last_name}"

  defp get_user_handle(%{first_name: first_name}),
    do: "@#{first_name}"
end
