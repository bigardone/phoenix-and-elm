defmodule PhoenixAndElm.PageController do
  use PhoenixAndElm.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
