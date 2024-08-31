defmodule Fileonchain.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :filename, :text
      add :data, :text
      add :mime_type, :text
      add :size, :integer
      add :created_by, references(:users, on_delete: :nothing), null: false
      add :created_at, :utc_datetime
      add :deleted_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
