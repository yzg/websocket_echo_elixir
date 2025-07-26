
defmodule WebsocketEcho.SocketHandler do
  @behaviour :cowboy_websocket

  # 初期化（ハンドシェイク）
  def init(req, _state) do
    {:cowboy_websocket, req, %{
    }}
  end

  # WebSocket 接続確立時
  def websocket_init(state) do
    IO.puts("WebSocket connected")
    {:ok, state}
  end

  # クライアントからのメッセージ受信時
  def websocket_handle({:text, msg}, state) do
    IO.puts("Received: #{msg}")

    {:reply, {:text, "Echo: #{msg}"}, state}
  end

  def websocket_handle(_data, state), do: {:ok, state}

  # WebSocket 切断時
  def websocket_terminate(_reason, _state) do
    IO.puts("WebSocket terminated")
    :ok
  end
end
