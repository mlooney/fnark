defmodule Fnark.Router do
  use Fnark.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", Fnark do
    pipe_through :browser # Use the default browser stack
    get "/", PageController, :index
  end

  scope "/api", Fnark do
    pipe_through :api
    resources "/links", LinkController, only: [:index]
    resources "/users", UserController, only: [:get]
    post "/session", SessionController,  :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", Fnark do
  #   pipe_through :api
  # end
end
