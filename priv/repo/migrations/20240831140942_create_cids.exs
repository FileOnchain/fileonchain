defmodule Fileonchain.Repo.Migrations.CreateCids do
  use Ecto.Migration

  def change do
    create table(:cids) do
      add :cid, :string
      add :data, :text

      timestamps(type: :utc_datetime)
    end
  end
end
