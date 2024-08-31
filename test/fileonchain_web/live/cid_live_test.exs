defmodule FileonchainWeb.CidLiveTest do
  use FileonchainWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fileonchain.CidsFixtures

  @create_attrs %{data: "some data", cid: "some cid"}
  @update_attrs %{data: "some updated data", cid: "some updated cid"}
  @invalid_attrs %{data: nil, cid: nil}

  defp create_cid(_) do
    cid = cid_fixture()
    %{cid: cid}
  end

  describe "Index" do
    setup [:create_cid]

    test "lists all cids", %{conn: conn, cid: cid} do
      {:ok, _index_live, html} = live(conn, ~p"/cids")

      assert html =~ "Listing Cids"
      assert html =~ cid.data
    end

    test "saves new cid", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/cids")

      assert index_live |> element("a", "New Cid") |> render_click() =~
               "New Cid"

      assert_patch(index_live, ~p"/cids/new")

      assert index_live
             |> form("#cid-form", cid: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#cid-form", cid: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cids")

      html = render(index_live)
      assert html =~ "Cid created successfully"
      assert html =~ "some data"
    end

    test "updates cid in listing", %{conn: conn, cid: cid} do
      {:ok, index_live, _html} = live(conn, ~p"/cids")

      assert index_live |> element("#cids-#{cid.id} a", "Edit") |> render_click() =~
               "Edit Cid"

      assert_patch(index_live, ~p"/cids/#{cid}/edit")

      assert index_live
             |> form("#cid-form", cid: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#cid-form", cid: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cids")

      html = render(index_live)
      assert html =~ "Cid updated successfully"
      assert html =~ "some updated data"
    end

    test "deletes cid in listing", %{conn: conn, cid: cid} do
      {:ok, index_live, _html} = live(conn, ~p"/cids")

      assert index_live |> element("#cids-#{cid.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#cids-#{cid.id}")
    end
  end

  describe "Show" do
    setup [:create_cid]

    test "displays cid", %{conn: conn, cid: cid} do
      {:ok, _show_live, html} = live(conn, ~p"/cids/#{cid}")

      assert html =~ "Show Cid"
      assert html =~ cid.data
    end

    test "updates cid within modal", %{conn: conn, cid: cid} do
      {:ok, show_live, _html} = live(conn, ~p"/cids/#{cid}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Cid"

      assert_patch(show_live, ~p"/cids/#{cid}/show/edit")

      assert show_live
             |> form("#cid-form", cid: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#cid-form", cid: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/cids/#{cid}")

      html = render(show_live)
      assert html =~ "Cid updated successfully"
      assert html =~ "some updated data"
    end
  end
end
