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
    case get_image_type(file.data) do
      {:ok, mime_type} ->
        "<img src=\"data:#{mime_type};base64,#{file.data}\" alt=\"#{file.filename}\" style=\"max-width: 100px; max-height: 100px; object-fit: contain;\" />"
      :error ->
        "<span class=\"text-gray-500\">Preview not available</span>"
    end
  end

  defp get_image_type(data) do
    case Base.decode64(data) do
      {:ok, decoded} ->
        cond do
          String.starts_with?(decoded, <<0xFF, 0xD8, 0xFF>>) -> {:ok, "image/jpeg"}
          String.starts_with?(decoded, <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>) -> {:ok, "image/png"}
          String.starts_with?(decoded, "GIF87a") or String.starts_with?(decoded, "GIF89a") -> {:ok, "image/gif"}
          String.starts_with?(decoded, "RIFF") and String.slice(decoded, 8, 4) == "WEBP" -> {:ok, "image/webp"}
          true -> :error
        end
      _ -> :error
    end
  end
end
