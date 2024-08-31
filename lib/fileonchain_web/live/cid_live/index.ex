defmodule FileonchainWeb.CidLive.Index do
  use FileonchainWeb, :live_view

  alias Fileonchain.Cids
  alias Fileonchain.Cids.Cid

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :cids, Cids.list_cids())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Cid")
    |> assign(:cid, Cids.get_cid!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Cid")
    |> assign(:cid, %Cid{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cids")
    |> assign(:cid, nil)
  end

  @impl true
  def handle_info({FileonchainWeb.CidLive.FormComponent, {:saved, cid}}, socket) do
    {:noreply, stream_insert(socket, :cids, cid)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    cid = Cids.get_cid!(id)
    {:ok, _} = Cids.delete_cid(cid)

    {:noreply, stream_delete(socket, :cids, cid)}
  end
end
