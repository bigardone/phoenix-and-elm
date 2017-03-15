defmodule PhoenixAndElm.LayoutView do
  use PhoenixAndElm.Web, :view

  def socket_url, do: System.get_env("WEBSOCKECT_URL") ||"ws://localhost:4000/socket/websocket"
end
