defmodule MayhemChatbot do
  require Logger

  @bot :mayhemchatbot
  @preprompt "You are a chatbot called @mayhemchatbot. Continue the conversation below:\n"

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  def handle({:text, "@mayhemchatbot " <> text, %{from: %{username: user}} = msg}, context) do
    Logger.info("Got tagged")

    prompt = """
    @#{user}: #{text}
    @mayhemchatbot:
    """

    reply(prompt, msg, context)
  end

  def handle({:text, text, msg}, context) do
    case msg do
      %{
        from: %{username: user},
        reply_to_message: %{from: %{username: "mayhemchatbot"}, text: reply_text}
      } ->
        Logger.info("Got reply chain message")

        prompt = """
        @mayhemchatbot: #{reply_text}
        @#{user}: #{text}
        @mayhemchatbot:
        """

        reply(prompt, msg, context)

      _ ->
        Logger.info("Skipping message")
    end
  end

  def reply(prompt, msg, context) do
    prompt = @preprompt <> prompt
    Logger.info("Generating reply to prompt: #{prompt}")

    res = complete_prompt(prompt)
    Logger.debug("Got reply: #{inspect(res)}")

    answer(
      context,
      res["text"],
      reply_to_message_id: msg.message_id
    )
  end

  # Dev catchall
  def complete_prompt(_) do
    %{"text" => "This is a fake reply :D"}
  end

  def complete_prompt(prompt) do
    {:ok, choices: [res]} = OpenAI.completions("davinci", prompt: prompt)
    res
  end
end
