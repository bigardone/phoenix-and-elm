defmodule PhoenixAndElm.ContactView do
  use PhoenixAndElm.Web, :view

  def render("index.json", %{page: page}), do: %{page: page}
end