defmodule MoonshineBrewery.Repo.Migrations.AddUserIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :main_id, :integer
    end
  end
end
