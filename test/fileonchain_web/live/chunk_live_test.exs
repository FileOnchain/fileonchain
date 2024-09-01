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
      {:error, {:redirect, %{to: "/users/log_in", flash: %{"error" => "You must log in to access this page."}}}} = live(conn, ~p"/chunks")
    end
  end

  describe "Show" do
    setup [:create_chunk]

    test "displays chunk", %{conn: conn, chunk: chunk} do
      {:error, {:redirect, %{to: "/users/log_in", flash: %{"error" => "You must log in to access this page."}}}} = live(conn, ~p"/chunks/#{chunk}")
    end
  end
end
