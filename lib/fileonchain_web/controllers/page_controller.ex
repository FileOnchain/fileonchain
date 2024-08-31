defmodule FileonchainWeb.PageController do
  use FileonchainWeb, :controller

  def home(conn, _params) do
    # Assuming you have a function to get the current user
    connected_user = get_connected_user(conn)

    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false, connected_user: connected_user)
  end

  defp get_connected_user(conn) do
    # Your logic to determine if the user is connected
    # This is just an example, replace with your actual logic
    conn.assigns[:current_user] != nil
  end
end
