defmodule MayhemChatbotTest do
  use ExUnit.Case
  doctest MayhemChatbot

  test "greets the world" do
    assert MayhemChatbot.hello() == :world
  end
end
