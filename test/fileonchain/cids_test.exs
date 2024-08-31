defmodule Fileonchain.ChunksTest do
  use Fileonchain.DataCase

  alias Fileonchain.Chunks

  describe "chunks" do
    alias Fileonchain.Chunks.Chunk

    import Fileonchain.ChunksFixtures

    @invalid_attrs %{data: nil, chunk: nil}

    test "list_chunks/0 returns all chunks" do
      chunk = chunk_fixture()
      assert Chunks.list_chunks() == [chunk]
    end

    test "get_chunk!/1 returns the chunk with given id" do
      chunk = chunk_fixture()
      assert Chunks.get_chunk!(chunk.id) == chunk
    end

    test "create_chunk/1 with valid data creates a chunk" do
      valid_attrs = %{data: "some data", chunk: "some chunk"}

      assert {:ok, %Chunk{} = chunk} = Chunks.create_chunk(valid_attrs)
      assert chunk.data == "some data"
      assert chunk.chunk == "some chunk"
    end

    test "create_chunk/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chunks.create_chunk(@invalid_attrs)
    end

    test "update_chunk/2 with valid data updates the chunk" do
      chunk = chunk_fixture()
      update_attrs = %{data: "some updated data", chunk: "some updated chunk"}

      assert {:ok, %Chunk{} = chunk} = Chunks.update_chunk(chunk, update_attrs)
      assert chunk.data == "some updated data"
      assert chunk.chunk == "some updated chunk"
    end

    test "update_chunk/2 with invalid data returns error changeset" do
      chunk = chunk_fixture()
      assert {:error, %Ecto.Changeset{}} = Chunks.update_chunk(chunk, @invalid_attrs)
      assert chunk == Chunks.get_chunk!(chunk.id)
    end

    test "delete_chunk/1 deletes the chunk" do
      chunk = chunk_fixture()
      assert {:ok, %Chunk{}} = Chunks.delete_chunk(chunk)
      assert_raise Ecto.NoResultsError, fn -> Chunks.get_chunk!(chunk.id) end
    end

    test "change_chunk/1 returns a chunk changeset" do
      chunk = chunk_fixture()
      assert %Ecto.Changeset{} = Chunks.change_chunk(chunk)
    end
  end
end
