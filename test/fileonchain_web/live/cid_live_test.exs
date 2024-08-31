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

    test "saves new chunk", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/chunks")

      assert index_live |> element("a", "New Chunk") |> render_click() =~
               "New Chunk"

      assert_patch(index_live, ~p"/chunks/new")

      assert index_live
             |> form("#chunk-form", chunk: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#chunk-form", chunk: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/chunks")

      html = render(index_live)
      assert html =~ "Chunk created successfully"
      assert html =~ "some data"
    end

    test "updates chunk in listing", %{conn: conn, chunk: chunk} do
      {:ok, index_live, _html} = live(conn, ~p"/chunks")

      assert index_live |> element("#chunks-#{chunk.id} a", "Edit") |> render_click() =~
               "Edit Chunk"

      assert_patch(index_live, ~p"/chunks/#{chunk}/edit")

      assert index_live
             |> form("#chunk-form", chunk: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#chunk-form", chunk: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/chunks")

      html = render(index_live)
      assert html =~ "Chunk updated successfully"
      assert html =~ "some updated data"
    end

    test "deletes chunk in listing", %{conn: conn, chunk: chunk} do
      {:ok, index_live, _html} = live(conn, ~p"/chunks")

      assert index_live |> element("#chunks-#{chunk.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#chunks-#{chunk.id}")
    end
  end

  describe "Show" do
    setup [:create_chunk]

    test "displays chunk", %{conn: conn, chunk: chunk} do
      {:ok, _show_live, html} = live(conn, ~p"/chunks/#{chunk}")

      assert html =~ "Show Chunk"
      assert html =~ chunk.data
    end

    test "updates chunk within modal", %{conn: conn, chunk: chunk} do
      {:ok, show_live, _html} = live(conn, ~p"/chunks/#{chunk}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Chunk"

      assert_patch(show_live, ~p"/chunks/#{chunk}/show/edit")

      assert show_live
             |> form("#chunk-form", chunk: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#chunk-form", chunk: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/chunks/#{chunk}")

      html = render(show_live)
      assert html =~ "Chunk updated successfully"
      assert html =~ "some updated data"
    end
  end
end
