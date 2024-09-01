defmodule FileonchainWeb.ChunkLiveTest do
  use FileonchainWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fileonchain.ChunksFixtures

  @create_attrs %{data: "some data", chunk: "some chunk"}
  @update_attrs %{data: "some updated data", chunk: "some updated chunk"}
  @invalid_attrs %{data: nil, chunk: nil}

  defp create_chunk(_) do
    chunk = chunk_fixture()
    %{chunk: chunk}
  end

  describe "Index" do
    setup [:create_chunk]

    test "lists all chunks", %{conn: conn, chunk: chunk} do
      {:ok, _index_live, html} = live(conn, ~p"/chunks")

      assert html =~ "Listing Chunks"
      assert html =~ chunk.data
    end
  end

  describe "Show" do
    setup [:create_chunk]

    test "displays chunk", %{conn: conn, chunk: chunk} do
      {:ok, _show_live, html} = live(conn, ~p"/chunks/#{chunk}")

      assert html =~ "Show Chunk"
      assert html =~ chunk.data
    end
  end
end
