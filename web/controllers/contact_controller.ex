defmodule PhoenixAndElm.ContactController do
  use PhoenixAndElm.Web, :controller

  alias PhoenixAndElm.{Repo, Contact}

  def index(conn, params) do
    page = Contact
      |> order_by(:first_name)
      |> Repo.paginate(params)

    render(conn, "index.json", page: page)
  end
end