defmodule FileonchainWeb.PageControllerTest do
  use FileonchainWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Allows anyone to upload small and large files to any substrate network, making them permanently available on-chain ⛓️"
  end
end
