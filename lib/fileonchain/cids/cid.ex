defmodule Fileonchain.Cids.Cid do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cids" do
    field :data, :string
    field :cid, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cid, attrs) do
    cid
    |> cast(attrs, [:cid, :data])
    |> validate_required([:cid, :data])
  end
end
