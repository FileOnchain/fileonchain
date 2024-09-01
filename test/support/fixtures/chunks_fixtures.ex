defmodule Fileonchain.ChunksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fileonchain.Chunks` context.
  """

  @doc """
  Generate a chunk.
  """
  def chunk_fixture(attrs \\ %{}) do
    {:ok, chunk} =
      attrs
      |> Enum.into(%{
        hash: "some hash",
        cid: "some cid",
        data: "some data"
      })
      |> Fileonchain.Chunks.create_chunk()

    chunk
  end
end
