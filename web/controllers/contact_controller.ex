defmodule PhoenixAndElm.ContactController do
  use PhoenixAndElm.Web, :controller

  alias PhoenixAndElm.{Repo, Contact}

  def index(conn, _params) do
    contacts = Repo.all Contact

    render(conn, "index.json", contacts: contacts)
  end
end