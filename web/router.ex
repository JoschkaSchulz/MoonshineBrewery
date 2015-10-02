defmodule MoonshineBrewery.Router do
  use MoonshineBrewery.Web, :router

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

  scope "/", MoonshineBrewery do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", MoonshineBrewery do
    pipe_through :api

    get "/login", UserController, :login

    get "/create_event", EventController, :create_event
    get "/show_events", EventController, :show_events
    get "/join_event", EventController, :join_event
  end
end
