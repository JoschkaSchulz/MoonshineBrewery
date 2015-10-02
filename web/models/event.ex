defmodule MoonshineBrewery.Event do
  use MoonshineBrewery.Web, :model

  schema "events" do
    field :name, :string
    field :description, :string
    field :date, Ecto.DateTime

    has_many :users, MoonshineBrewery.User

    timestamps
  end

  @required_fields ~w(name description date)
  @optional_fields ~w()

  def with_id(query, id) do
    from events in query,
    where: events.id == ^id
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
