defmodule PhoenixAndElm.ContactView do
  use PhoenixAndElm.Web, :view

  def render("index.json", %{contacts: contacts}), do: %{contacts: contacts}
end