defmodule MoonshineBrewery.UserEvent do
  use MoonshineBrewery.Web, :model

  schema "user_events" do
    belongs_to :event,  MoonshineBrewery.Event, references: :id
    belongs_to :user,   MoonshineBrewery.User,  references: :id

    timestamps
  end

  @required_fields ~w(user_id, event_id)
  @optional_fields ~w()

  def user_and_event(query, user_id, event_id) do
    from user_events in query,
    where: user_events.user_id == ^user_id,
    where: user_events.event_id == ^event_id
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
