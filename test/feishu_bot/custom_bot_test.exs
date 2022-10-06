defmodule FeishuBot.CustomBotTest do
  use ExUnit.Case
  alias FeishuBot.CustomBot

  def mock_bot() do
    CustomBot.default_bot(adapter: Tesla.Mock, debug: true)
  end

  describe "send_text" do
    test "mock" do
      Tesla.Mock.mock(fn _ ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body: %{
             StatusCode: 0,
             StatusMessage: "success"
           }
         }}
      end)

      {:ok, _env} = CustomBot.send_text("hi feishu", bot: mock_bot())
    end

    @tag :manual
    test "remote" do
      CustomBot.send_text("hi feishu",
        bot: CustomBot.default_bot(debug: true)
      )

      # |> IO.inspect(label: "resp")
    end
  end

  test "gen_sign" do
    sec = "zJlvvSoQWuukwGnCzBVtve"
    want = "jW2NVlpvB/5izBjoq8Kmrt6eddAeHPz2BSCfiXo3v9U="
    got = CustomBot.gen_sign(sec, 1_664_944_271)
    assert got == want
  end
end
