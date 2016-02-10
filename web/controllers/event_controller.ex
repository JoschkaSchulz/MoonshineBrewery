alias MoonshineBrewery.Event
alias MoonshineBrewery.User
alias MoonshineBrewery.UserEvent
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

  def join(conn, %{"token" => token, "event_id" => event_id}) do
    valid_token(conn, token)

    event = Event
    |> Event.with_id(event_id)
    |> Repo.one

    current_user = User
    |> User.with_token(token)
    |> Repo.one

    user_ids = []
    user_ids = for u <- event.users do
      u.id
    end

    status = "already joined"
    unless current_user.id in user_ids do
      user_event = %UserEvent{user_id: current_user.id, event_id: event.id}
      Repo.insert(user_event)
      status = "joined"
    end

    render conn, response: %{status: status,
                             event: %{id: event.id, name: event.name, description: event.description, date: event.date},
                             user: %{id: current_user.id}}
  end

  def leave(conn, %{"token" => token ,"event_id" => event_id}) do
    valid_token(conn, token)

    current_user = User
    |> User.with_token(token)
    |> Repo.one

    user_event = UserEvent
    |> UserEvent.user_and_event(current_user.id, event_id)
    |> Repo.one

    if is_map(user_event) do
      Repo.delete!(user_event)
      render conn, response: %{status: "left"}
    else
      render conn, response: %{status: "not found"}
    end
  end

  def show(conn, %{"token" => token ,"event_id" => event_id}) do
    valid_token(conn, token)

    event = Event
    |> Event.with_id(event_id)
    |> Repo.one

    users = Map.new()
    user = for u <- event.users do
      %{id: u.id, token: u.token, name: u.name}
    end

    render conn, response: %{event: %{id: event.id, name: event.name, description: event.description, date: event.date, users: user, users_count: length(user)}}
  end

  def list(conn, %{"token" => token, "user_id" => user_id}) do
    valid_token(conn, token)

    user = User
    |> User.with_id(user_id)
    |> Repo.one

    response = Map.new()
    events = for event <- user.events do
      %{id: event.id, name: event.name, description: event.description, date: event.date}
    end
    response = Map.put(response, :count, length(events))
    response = Map.put(response, :events, events)
    render conn, response: response
  end

  def list(conn, %{"token" => token}) do
    valid_token(conn, token)

    events = Event |> Repo.all

    response = Map.new()
    events = for event <- events do
      %{id: event.id, name: event.name, description: event.description, date: event.date}
    end
    response = Map.put(response, :count, length(events))
    response = Map.put(response, :events, events)

    render conn, response: response
  end

  def create(conn, %{"token" => token, "name" => name, "date" => date, "description" => description}) do
    valid_token(conn, token)

    {ok, datetime} = Ecto.DateTime.cast(date)
    event = %Event{name: name, date: datetime, description: description}
    {ok, model} = Repo.insert(event)

    render conn, response: %{event: %{id: model.id, name: model.name, description: model.description, date: model.date}}
  end
end
