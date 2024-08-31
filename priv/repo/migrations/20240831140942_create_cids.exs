defmodule Fileonchain.Repo.Migrations.CreateCids do
  use Ecto.Migration

  def change do
    create table(:cids) do
      add :cid, :string
      add :data, :text
      add :tx_hash, :text
      add :tx_index, :integer
      add :tx_block, :integer
      add :tx_timestamp, :integer
      add :tx_from, :text
      add :created_by, references(:users, on_delete: :nothing), null: false
      add :created_at, :utc_datetime
      add :deleted_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
