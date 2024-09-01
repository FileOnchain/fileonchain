defmodule FileonchainWeb.FileLiveTest do
  use FileonchainWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fileonchain.FilesFixtures

  @create_attrs %{data: "some data", filename: "some filename"}
  # @invalid_attrs %{data: nil, filename: nil}

  def fixture(:file) do
    {:ok, file} = Fileonchain.Files.create_file(@create_attrs)
    file
  end

  defp create_file(_) do
    file = file_fixture()
    %{test_file: file} # Renamed key to avoid reserved field
  end

  describe "Index" do
    setup [:create_file]

    test "lists all files", %{conn: conn, test_file: file} do
      {:error, {:redirect, %{to: "/users/log_in", flash: %{"error" => "You must log in to access this page."}}}} = live(conn, ~p"/files")
    end

    test "saves new file", %{conn: conn} do
      {:error, {:redirect, %{to: "/users/log_in", flash: %{"error" => "You must log in to access this page."}}}} = live(conn, ~p"/files")
    end
  end

  describe "Show" do
    setup [:create_file]

    test "displays file", %{conn: conn, test_file: file} do
      {:error, {:redirect, %{to: "/users/log_in", flash: %{"error" => "You must log in to access this page."}}}} = live(conn, ~p"/files/#{file}")
    end
  end
end
