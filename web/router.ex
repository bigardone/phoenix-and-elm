defmodule PhoenixAndElm.Router do
  use PhoenixAndElm.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api", PhoenixAndElm do
    pipe_through :api

    resources "/contacts", ContactController, only: [:index, :show]
  end

  scope "/", PhoenixAndElm do
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
  end
end
