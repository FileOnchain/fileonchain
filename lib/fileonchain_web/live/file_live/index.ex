defmodule FileonchainWeb.FileLive.Index do
  use FileonchainWeb, :live_view

  alias Fileonchain.Files
  alias Fileonchain.Files.File

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :files, Files.list_files())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New File")
    |> assign(:file, %File{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Files")
    |> assign(:file, nil)
  end

  @impl true
  def handle_info({FileonchainWeb.FileLive.FormComponent, {:saved, file}}, socket) do
    {:noreply, stream_insert(socket, :files, file)}
  end

  @impl true
  def handle_event("hide", %{"id" => id}, socket) do
    file = Files.get_file!(id)
    {:ok, _} = Files.delete_file(file)

    {:noreply, stream_delete(socket, :files, file)}
  end
end
