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

  # Updated function to render file preview
  def render_file_preview(file) do
    if is_png?(file.data) do
      "<img src=\"data:image/png;base64,#{file.data}\" alt=\"#{file.filename}\" style=\"max-width: 100px; max-height: 100px;\" />"
    else
      "<span class=\"text-gray-500\">Preview not available</span>"
    end
  end

  defp is_png?(data) do
    case Base.decode64(data) do
      {:ok, decoded} -> String.starts_with?(decoded, <<137, 80, 78, 71, 13, 10, 26, 10>>)
      _ -> false
    end
  end
end
