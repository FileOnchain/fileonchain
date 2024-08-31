defmodule FileonchainWeb.FileLiveTest do
  use FileonchainWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fileonchain.FilesFixtures

  @create_attrs %{data: "some data", filename: "some filename"}
  @update_attrs %{data: "some updated data", filename: "some updated filename"}
  @invalid_attrs %{data: nil, filename: nil}

  defp create_file(_) do
    file = file_fixture()
    %{file: file}
  end

  describe "Index" do
    setup [:create_file]

    test "lists all files", %{conn: conn, file: file} do
      {:ok, _index_live, html} = live(conn, ~p"/files")

      assert html =~ "Listing Files"
      assert html =~ file.data
    end

    test "saves new file", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/files")

      assert index_live |> element("a", "New File") |> render_click() =~
               "New File"

      assert_patch(index_live, ~p"/files/new")

      assert index_live
             |> form("#file-form", file: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#file-form", file: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/files")

      html = render(index_live)
      assert html =~ "File created successfully"
      assert html =~ "some data"
    end

    test "updates file in listing", %{conn: conn, file: file} do
      {:ok, index_live, _html} = live(conn, ~p"/files")

      assert index_live |> element("#files-#{file.id} a", "Edit") |> render_click() =~
               "Edit File"

      assert_patch(index_live, ~p"/files/#{file}/edit")

      assert index_live
             |> form("#file-form", file: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#file-form", file: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/files")

      html = render(index_live)
      assert html =~ "File updated successfully"
      assert html =~ "some updated data"
    end

    test "deletes file in listing", %{conn: conn, file: file} do
      {:ok, index_live, _html} = live(conn, ~p"/files")

      assert index_live |> element("#files-#{file.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#files-#{file.id}")
    end
  end

  describe "Show" do
    setup [:create_file]

    test "displays file", %{conn: conn, file: file} do
      {:ok, _show_live, html} = live(conn, ~p"/files/#{file}")

      assert html =~ "Show File"
      assert html =~ file.data
    end

    test "updates file within modal", %{conn: conn, file: file} do
      {:ok, show_live, _html} = live(conn, ~p"/files/#{file}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit File"

      assert_patch(show_live, ~p"/files/#{file}/show/edit")

      assert show_live
             |> form("#file-form", file: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#file-form", file: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/files/#{file}")

      html = render(show_live)
      assert html =~ "File updated successfully"
      assert html =~ "some updated data"
    end
  end
end
