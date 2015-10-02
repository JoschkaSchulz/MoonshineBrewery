defmodule MoonshineBrewery.User do
  use MoonshineBrewery.Web, :model

  schema "users" do
    field :token, :string
    field :main_id, :integer

    has_many :events, MoonshineBrewery.Event

    timestamps
  end

  @required_fields ~w(token)
  @optional_fields ~w()

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
