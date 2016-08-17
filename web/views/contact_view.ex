defmodule PhoenixAndElm.ContactView do
  use PhoenixAndElm.Web, :view

  def render("index.json", %{page: page, search: search}), do: Map.put(page, :search, search)
end