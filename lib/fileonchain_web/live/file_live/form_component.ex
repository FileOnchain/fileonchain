defmodule FileonchainWeb.FileLive.FormComponent do
  use FileonchainWeb, :live_component
  require Logger

  alias Fileonchain.Files

  @impl true
  def mount(socket) do
    {:ok, allow_upload(socket, :file,
      accept: :any,
      max_entries: 1,
      max_file_size: 100_000_000  # 100 MB
    )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="overlay mx-auto max-w-md p-12 bg-brand-900 bg-opacity-50 text-white rounded-lg shadow-lg">
      <.header class="text-center text-white text-2xl">
        <%= @title %>
        <:subtitle>Use this form to manage file records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="file-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-6 bg-brand-800"
      >
        <.input field={@form[:filename]} type="text" label="Filename" required class="w-full p-4 border border-brand-700 rounded bg-brand-900 text-white" />

        <div id="dropzone-wrapper" class="mt-4" phx-drop-target={@uploads.file.ref}>
          <.live_file_input upload={@uploads.file} class="hidden" />
          <div class="dropzone bg-brand-900 border-2 border-dashed border-brand-600 rounded-lg p-6 text-center cursor-pointer">
            <%= if Enum.empty?(@uploads.file.entries) do %>
              <p class="text-brand-400">Drag and drop a file here, or click to select</p>
            <% else %>
              <%= for entry <- @uploads.file.entries do %>
                <div class="text-sm text-brand-400"><%= entry.client_name %></div>
                <div class="mt-2">
                  <progress value={entry.progress} max="100" class="w-full bg-brand-700"><%= entry.progress %>%</progress>
                </div>
              <% end %>
            <% end %>
          </div>
        </div>

        <%= for err <- upload_errors(@uploads.file) do %>
          <div class="text-secondary-light text-sm"><%= error_to_string(err) %></div>
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving..." class="w-full bg-secondary hover:bg-secondary-dark text-white p-4 rounded">
            Save File
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{file: file} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Files.change_file(file))
     end)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :file, ref)}
  end

  def handle_event("save", %{"file" => file_params}, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :file, fn %{path: path}, _entry ->
        {:ok, Base.encode64(File.read!(path))}
      end)

    file_params = Map.put(file_params, "data", List.first(uploaded_files) || "")
    save_file(socket, socket.assigns.action, file_params)
  end

  defp save_file(socket, :new, file_params) do
    case Files.create_file(file_params) do
      {:ok, file} ->
        file_data = file_params["data"]
        chunk_size = 256 * 1024  # 256 KB
        chunks = chunk_binary(file_data, chunk_size)

        chunks_results =
          Enum.map(chunks, fn chunk ->
            hash = Blake3.hash(chunk) |> Base.encode16(case: :lower)
            case Fileonchain.Chunks.create_chunk(%{hash: hash, cid: "dummy_cid", data: chunk}) do
              {:ok, _chunk} ->
                # Send remark transaction
                sender_seed = System.get_env("POLKADOT_SENDER_SEED") || "//Alice"
                Logger.info("Sending remark transaction with sender seed: #{sender_seed} and hash: #{hash}")
                {tx_hash, exit_code} = System.cmd("node", ["assets/dist/sendRemark.js", sender_seed, hash])
                Logger.info("Remark transaction result: #{tx_hash}, exit code: #{exit_code}")
                if exit_code == 0 do
                  Logger.info("Remark transaction successful with tx hash: #{String.trim(tx_hash)}")
                  {:ok, String.trim(tx_hash)}
                else
                  Logger.error("Failed to send remark: #{String.trim(tx_hash)}")
                  {:error, "Failed to send remark: #{String.trim(tx_hash)}"}
                end
              error -> error
            end
          end)

        if Enum.all?(chunks_results, fn {:ok, _} -> true; _ -> false end) do
          notify_parent({:saved, file})

          {:noreply,
           socket
           |> put_flash(:info, "File and Chunks created successfully, remarks sent to Polkadot")
           |> push_patch(to: socket.assigns.patch)}
        else
          {:noreply,
           socket
           |> put_flash(:error, "File created but failed to create some Chunks or send remarks")
           |> push_patch(to: socket.assigns.patch)}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp chunk_binary(binary, chunk_size) do
    chunk_binary(binary, chunk_size, [])
  end

  defp chunk_binary(<<>>, _chunk_size, acc), do: Enum.reverse(acc)
  defp chunk_binary(binary, chunk_size, acc) when byte_size(binary) < chunk_size do
    Enum.reverse([binary | acc])
  end
  defp chunk_binary(binary, chunk_size, acc) do
    <<chunk::binary-size(chunk_size), rest::binary>> = binary
    chunk_binary(rest, chunk_size, [chunk | acc])
  rescue
    MatchError -> Enum.reverse([binary | acc])
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp error_to_string(:too_large), do: "The file is too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
