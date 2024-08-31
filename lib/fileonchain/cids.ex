defmodule Fileonchain.Cids do
  @moduledoc """
  The Cids context.
  """

  import Ecto.Query, warn: false
  alias Fileonchain.Repo

  alias Fileonchain.Cids.Cid

  @doc """
  Returns the list of cids.

  ## Examples

      iex> list_cids()
      [%Cid{}, ...]

  """
  def list_cids do
    Repo.all(Cid)
  end

  @doc """
  Gets a single cid.

  Raises `Ecto.NoResultsError` if the Cid does not exist.

  ## Examples

      iex> get_cid!(123)
      %Cid{}

      iex> get_cid!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cid!(id), do: Repo.get!(Cid, id)

  @doc """
  Creates a cid.

  ## Examples

      iex> create_cid(%{field: value})
      {:ok, %Cid{}}

      iex> create_cid(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cid(attrs \\ %{}) do
    %Cid{}
    |> Cid.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cid.

  ## Examples

      iex> update_cid(cid, %{field: new_value})
      {:ok, %Cid{}}

      iex> update_cid(cid, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cid(%Cid{} = cid, attrs) do
    cid
    |> Cid.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cid.

  ## Examples

      iex> delete_cid(cid)
      {:ok, %Cid{}}

      iex> delete_cid(cid)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cid(%Cid{} = cid) do
    Repo.delete(cid)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cid changes.

  ## Examples

      iex> change_cid(cid)
      %Ecto.Changeset{data: %Cid{}}

  """
  def change_cid(%Cid{} = cid, attrs \\ %{}) do
    Cid.changeset(cid, attrs)
  end
end
