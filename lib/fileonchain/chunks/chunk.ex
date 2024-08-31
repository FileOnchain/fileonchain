defmodule Fileonchain.Chunks.Chunk do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chunks" do
    field :hash, :string
    field :cid, :string
    field :data, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chunk, attrs) do
    chunk
    |> cast(attrs, [:hash, :cid, :data])
    |> validate_required([:hash, :cid, :data])
  end
end
