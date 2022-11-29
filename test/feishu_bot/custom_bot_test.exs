defmodule FeishuBot.CustomBotTest do
  use ExUnit.Case
  alias FeishuBot.CustomBot

  describe "send_text" do
    test "mock send" do
      mocker = fn request ->
        response = %Req.Response{status: 200, body: "mock-sent!"}
        {request, response}
      end

      assert %Req.Response{
               status: 200,
               headers: [],
               body: "mock-sent!",
               private: %{}
             } ==
               CustomBot.send_text("hi feishu", adapter: mocker)

      #  |> IO.inspect(label: "mock send")
    end

    @tag :manual
    test "remote send" do
      # [
      #   {"server", "dsa-nginx"},
      #   {"content-type", "application/json"},
      #   {"content-length", "42"},
      #   {"request-id", "b8bd60d4389bd5e1549dcd2ac970049e"},
      #   {"x-lgw-dst-svc",
      #    "j5Ino-lluheh4w8FUAOTOtY2Ph0F5FPAcUge1GhtiQK92AjSHT0G_gjQtrj57yTcgC2a2KFlUNGmvNk3azUxPxvI_DMPVrZcaPrBdCZxZDZOYkkIo5U25c9tVRnzKEr3zNOM_3e0PD9u1IxS3Aw="},
      #   {"x-request-id", "b8bd60d4389bd5e1549dcd2ac970049e"},
      #   {"x-tt-logid", "202211291110110101581130450E2AFC7D"},
      #   {"server-timing", "inner; dur=283, cdn-cache;desc=MISS, origin;dur=359, edge;dur=0"},
      #   {"x-tt-trace-host",
      #    "01a7d52cc36dc383e507f589300c4f94269f26eb7819c93a8c6c9aa0da70a1540ac87458a1771fd23675eae4b996b1c026ef8afdefff85e1c809fc23371ed10a35da7dda379a1f2611cf5b19d3d4ff38ad4e191ff27c1f178cddcdcf7022852acc73320e7a7e9558d55d46ba002ea6102b"},
      #   {"x-tt-trace-id", "00-c15d0c4b03010ed22694339c7e270000-c15d0c4b03010ed2-01"},
      #   {"x-timestamp", "1669691411.464"},
      #   {"x-request-ip", "23.214.112.13"},
      #   {"x-dsa-trace-id", "1669691411b8bd60d4389bd5e1549dcd2ac970049e"},
      #   {"x-dsa-origin-status", "200"},
      #   {"expires", "Tue, 29 Nov 2022 03:10:11 GMT"},
      #   {"cache-control", "max-age=0, no-cache, no-store"},
      #   {"pragma", "no-cache"},
      #   {"date", "Tue, 29 Nov 2022 03:10:11 GMT"},
      #   {"x-cache",
      #    "TCP_MISS from a23-214-112-13.deploy.akamaitechnologies.com (AkamaiGHost/10.10.2-45048955) (-)"},
      #   {"connection", "keep-alive"},
      #   {"x-tt-trace-tag", "id=16;cdn-cache=miss;type=dyn"},
      #   {"server-timing", "cdn-cache; desc=MISS, edge; dur=4, origin; dur=561"},
      #   {"x-origin-response-time", "561,23.214.112.13"},
      #   {"x-akamai-request-id", "2088679d"}
      # ]
      %Req.Response{
        status: 200,
        headers: _headers,
        body: %{"StatusCode" => 0, "StatusMessage" => "success"},
        private: %{}
      } = CustomBot.send_text("hi feishu", debug: true)

      # |> IO.inspect(label: "resp")
    end
  end

  @tag :manual
  test "get_sign_info" do
    CustomBot.get_sign_info(%{something: "test"}, "testsecret")
    |> IO.inspect(label: "with-sign-info")
  end

  test "gen_signature" do
    sec = "zJlvvSoQWuukwGnCzBVtve"
    want = "jW2NVlpvB/5izBjoq8Kmrt6eddAeHPz2BSCfiXo3v9U="
    got = CustomBot.gen_signature(sec, 1_664_944_271)
    assert got == want
  end
end
