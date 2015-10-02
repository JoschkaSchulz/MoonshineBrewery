defmodule MoonshineBrewery.Repo.Migrations.CreateUserEvents do
  use Ecto.Migration

  def change do
    create table(:user_events) do
      add :user_id, :integer
      add :event_id, :integer

      timestamps
    end
  end
end
