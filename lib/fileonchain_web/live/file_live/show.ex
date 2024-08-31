defmodule FileonchainWeb.FileLive.Show do
  use FileonchainWeb, :live_view

  alias Fileonchain.Files

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:file, Files.get_file!(id))}
  end

  defp page_title(:show), do: "Show File"

  # Import render_file_preview and format_file_size functions from Index
  import FileonchainWeb.FileLive.Index, only: [render_file_preview: 2, format_file_size: 1]
end
