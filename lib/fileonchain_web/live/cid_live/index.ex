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
  def handle_event("hide", %{"id" => id}, socket) do
    cid = Cids.get_cid!(id)
    {:ok, _} = Cids.delete_cid(cid)

    {:noreply, stream_delete(socket, :cids, cid)}
  end

  # Function to render CID preview
  def render_cid_preview(cid) do
    case get_image_type(cid.data) do
      {:ok, mime_type} ->
        "<img src=\"data:#{mime_type};base64,#{cid.data}\" alt=\"CID Preview\" style=\"max-width: 100px; max-height: 100px; object-fit: contain;\" />"
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

  # Function to format CID data size
  def format_cid_size(data) do
    case Base.decode64(data) do
      {:ok, decoded} ->
        byte_size = byte_size(decoded)
        cond do
          byte_size < 1024 -> "#{byte_size} B"
          byte_size < 1024 * 1024 -> "#{Float.round(byte_size / 1024, 2)} KB"
          byte_size < 1024 * 1024 * 1024 -> "#{Float.round(byte_size / (1024 * 1024), 2)} MB"
          true -> "#{Float.round(byte_size / (1024 * 1024 * 1024), 2)} GB"
        end
      _ -> "N/A"
    end
  end
end
