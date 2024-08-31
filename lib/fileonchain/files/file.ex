defmodule Fileonchain.Files.File do
  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field :data, :string
    field :filename, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:filename, :data])
    |> validate_required([:filename, :data])
  end
end
