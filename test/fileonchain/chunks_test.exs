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
      valid_attrs = %{hash: "some hash", cid: "some cid", data: "some data"}

      assert {:ok, %Chunk{} = chunk} = Chunks.create_chunk(valid_attrs)
      assert chunk.hash == "some hash"
      assert chunk.cid == "some cid"
      assert chunk.data == "some data"
    end

    test "create_chunk/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chunks.create_chunk(@invalid_attrs)
    end
  end
end
