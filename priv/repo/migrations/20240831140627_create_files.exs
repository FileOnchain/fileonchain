defmodule Fileonchain.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :filename, :text
      add :data, :bytes

      timestamps(type: :utc_datetime)
    end
  end
end
