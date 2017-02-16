defmodule PhoenixAndElm.ContactController do
  use PhoenixAndElm.Web, :controller

  alias PhoenixAndElm.Contact

  def index(conn, params) do
    page = Contact
      |> order_by(:first_name)
      |> Repo.paginate(params)

    render conn, page: page, search: search
  end
end
