defmodule Oiseau.Router do
  use Oiseau.Web, :router

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

  scope "/", Oiseau do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

  end

  # Other scopes may use custom stacks.
  scope "/api", Oiseau do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    get "/magic/:origin_lat/:origin_lon/:destiny_lat/:destiny_lon", RouteController, :do_the_magic
  end
end
