defmodule Fileonchain.CidsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fileonchain.Cids` context.
  """

  @doc """
  Generate a cid.
  """
  def cid_fixture(attrs \\ %{}) do
    {:ok, cid} =
      attrs
      |> Enum.into(%{
        cid: "some cid",
        data: "some data"
      })
      |> Fileonchain.Cids.create_cid()

    cid
  end
end
