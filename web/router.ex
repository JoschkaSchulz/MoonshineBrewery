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

    get "/users/login", UserController, :login

    scope "/events" do
      get "/create",  EventController, :create
      get "/list",    EventController, :list
      get "/join",    EventController, :join
      get "/leave",   EventController, :leave
      get "/show",   EventController, :show
    end
  end
end
