defmodule FeishuBot.CustomBot do
  @moduledoc """
  FeishuBot CustomBot as https://open.feishu.cn/document/ukTMukTMukTM/ucTM5YjL3ETO24yNxkjN?lang=zh-CN#348211be
  """
  require Logger

  @open_host "https://open.feishu.cn"

  @enforce_keys [:hook_id]
  defstruct hook_id: "", sign_key: nil

  @webhook_bot_path "/open-apis/bot/v2/hook"

  def new(hook_id, opts \\ []) do
    %__MODULE__{
      hook_id: hook_id,
      sign_key: opts[:sign_key]
    }
  end

  def send_text(text, opts \\ []) when is_binary(text) do
    %{
      msg_type: "text",
      content: %{
        text: text
      }
    }
    |> send_msg(opts)
  end

  def send_msg(msg, opts \\ []) when is_map(msg) and is_list(opts) do
    bot = opts[:bot] || default_bot()
    msg = get_sign_info(msg, bot.sign_key)
    path = @webhook_bot_path <> "/" <> bot.hook_id

    base_req(opts)
    |> Req.post!(url: path, json: msg)
  end

  def get_sign_info(info, nil), do: info

  def get_sign_info(%{} = info, secret) when is_binary(secret) do
    tm =
      DateTime.utc_now()
      |> DateTime.to_unix()

    %{
      timestamp: tm |> to_string(),
      sign: gen_signature(secret, tm)
    }
    |> Map.merge(info)
  end

  def gen_signature(secret, timestamp) when is_binary(secret) do
    key = "#{timestamp}\n#{secret}"

    :crypto.mac(:hmac, :sha256, key, "")
    |> Base.encode64()
  end

  def default_bot(opts \\ []) do
    new(
      System.fetch_env!("FEISHU_BOT_DEFAULT_HOOK_ID"),
      opts
      |> Keyword.merge(sign_key: System.get_env("FEISHU_BOT_DEFAULT_SIGN_KEY"))
    )
  end

  def base_req(_opts \\ []) do
    Req.new(base_url: @open_host)
  end
end
