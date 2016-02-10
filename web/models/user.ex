defmodule MoonshineBrewery.User do
  use MoonshineBrewery.Web, :model

  schema "users" do
    has_many :user_events, MoonshineBrewery.UserEvent
    has_many :events, through: [:user_events, :event]

    field :name, :string
    field :token, :string
    field :main_id, :integer

    timestamps
  end

  @required_fields ~w(token)
  @optional_fields ~w()

  def with_token(query, token) do
    from users in query,
    where: users.token == ^token,
    preload: :events
  end

  def with_id(query, user_id) do
    from users in query,
    where: users.id == ^user_id,
    preload: :events
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
