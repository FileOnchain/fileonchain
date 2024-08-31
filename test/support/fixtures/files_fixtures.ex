defmodule Fileonchain.FilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fileonchain.Files` context.
  """

  @doc """
  Generate a file.
  """
  def file_fixture(attrs \\ %{}) do
    {:ok, file} =
      attrs
      |> Enum.into(%{
        data: "some data",
        filename: "some filename"
      })
      |> Fileonchain.Files.create_file()

    file
  end
end
