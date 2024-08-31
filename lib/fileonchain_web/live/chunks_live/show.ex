defmodule FileonchainWeb.ChunkLive.Show do
  use FileonchainWeb, :live_view

  alias Fileonchain.Chunks

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:chunk, Chunks.get_chunk!(id))}
  end

  defp page_title(:show), do: "Show Chunk"
end
