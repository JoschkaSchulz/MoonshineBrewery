alias MoonshineBrewery.Event
alias MoonshineBrewery.Repo

defmodule MoonshineBrewery.EventController do
  use MoonshineBrewery.Web, :controller

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

  def join_event(conn, %{"token" => token, "event_id" => event_id}) do
    valid_token(conn, token)

    event = Event
    |> Event.with_id(event_id)
    |> Repo.one

    render conn, response: %{status: 200, event: %{id: event.id, name: event.name, description: event.description, date: event.date}}
  end

  def leave_event(conn, %{"token" => token ,"event_id" => event_id}) do
    valid_token(conn, token)

    event = Event
    |> Event.with_id(event_id)
    |> Repo.one

    render conn, response: %{status: 200, event: %{id: event.id, name: event.name, description: event.description, date: event.date}}
  end

  def show_events(conn, %{"token" => token}) do
    valid_token(conn, token)

    events = Event |> Repo.all

    response = Map.new()
    events = for event <- events do
      %{id: event.id, name: event.name, description: event.description, date: event.date}
    end
    response = Map.put(response, :status, 200)
    response = Map.put(response, :events, events)
    render conn, response: response
  end

  def create_event(conn, %{"token" => token,
                           "name" => name,
                           "date" => date,
                           "description" => description}) do
    valid_token(conn, token)

    {ok, datetime} = Ecto.DateTime.cast(date)
    event = %Event{name: name, date: datetime, description: description}
    {ok, model} = Repo.insert(event)

    render conn, response: %{status: 200, event: %{name: model.name, description: model.description, date: model.date}}
  end
end
