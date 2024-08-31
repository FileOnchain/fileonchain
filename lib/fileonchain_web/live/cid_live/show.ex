defmodule FileonchainWeb.CidLive.Show do
  use FileonchainWeb, :live_view

  alias Fileonchain.Cids

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cid, Cids.get_cid!(id))}
  end

  defp page_title(:show), do: "Show Cid"
  defp page_title(:edit), do: "Edit Cid"
end
