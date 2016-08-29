defmodule PhoenixAndElm.ContactController do
  use PhoenixAndElm.Web, :controller

  alias PhoenixAndElm.Contact

  def index(conn, params) do
    search = Map.get(params, "search") || ""

    page = Contact
      |> Contact.search(search)
      |> order_by(:first_name)
      |> Repo.paginate(params)

    render conn, page: page, search: search
  end

  def show(conn, %{"id" => id}) do
    contact = Contact
    |> Repo.get(id)

    case contact do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{reason: "Contact nof found"})
      _ ->
        render conn, contact: contact
    end
  end
end