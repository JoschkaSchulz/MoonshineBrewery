defmodule MoonshineBrewery.EventController do
  use MoonshineBrewery.Web, :controller

  plug :action

  def valid_token(conn, token) do
    query = from users in MoonshineBrewery.User,
            where: users.token == ^token,
            select: users
    user = MoonshineBrewery.Repo.all query

    if(length(user) == 0) do
      render conn, response: %{response: "kthxbai"}
      raise "No valid token!"
    end
  end

  def create_event(conn, %{"token" => token,
                           "name" => name,
                           "date" => date,
                           "description" => description}) do
    valid_token(conn, token)

    datetime = Ecto.DateTime.cast(date)
    %MoonshineBrewery.Event{name: name, datetime: datetime, description: description}

    render conn, response: %{response: "hai"}
  end
end
