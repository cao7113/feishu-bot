defmodule FeishuBot.Client do
  def new(opts \\ []) do
    headers = opts[:headers] || []
    adapter = opts[:adapter] || Tesla.Adapter.Hackney
    base_url = opts[:base_url] || "https://open.feishu.cn"

    mw = [
      {Tesla.Middleware.BaseUrl, base_url},
      {Tesla.Middleware.Headers, headers},
      {Tesla.Middleware.JSON, [engine_opts: [keys: :atoms]]},
      {Tesla.Middleware.Logger, [debug: opts[:debug] || false]}
    ]

    Tesla.client(mw, adapter)
  end
end
