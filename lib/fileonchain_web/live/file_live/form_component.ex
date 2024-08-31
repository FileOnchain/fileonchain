defmodule FileonchainWeb.FileLive.FormComponent do
  use FileonchainWeb, :live_component

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
    <div class="overlay mx-auto max-w-md p-12 bg-gray-900 bg-opacity-50 text-white rounded-lg shadow-lg">
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
        class="space-y-6 bg-gray-900"
      >
        <.input field={@form[:filename]} type="text" label="Filename" required class="w-full p-4 border border-gray-700 rounded bg-gray-800 text-white" />

        <div id="dropzone-wrapper" class="mt-4" phx-drop-target={@uploads.file.ref}>
          <.live_file_input upload={@uploads.file} class="hidden" />
          <div class="dropzone bg-gray-800 border-2 border-dashed border-gray-600 rounded-lg p-6 text-center cursor-pointer">
            <%= if Enum.empty?(@uploads.file.entries) do %>
              <p class="text-gray-400">Drag and drop a file here, or click to select</p>
            <% else %>
              <%= for entry <- @uploads.file.entries do %>
                <div class="text-sm text-gray-400"><%= entry.client_name %></div>
                <div class="mt-2">
                  <progress value={entry.progress} max="100" class="w-full"><%= entry.progress %>%</progress>
                </div>
                <button type="button" phx-click="cancel-upload" phx-value-ref={entry.ref} class="mt-2 text-red-500">&times; Cancel</button>
              <% end %>
            <% end %>
          </div>
        </div>

        <%= for err <- upload_errors(@uploads.file) do %>
          <div class="text-red-500 text-sm"><%= error_to_string(err) %></div>
        <% end %>

        <:actions>
          <.button phx-disable-with="Saving..." class="w-full bg-blue-500 text-white p-4 rounded hover:bg-blue-600">
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
        notify_parent({:saved, file})

        {:noreply,
         socket
         |> put_flash(:info, "File created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp error_to_string(:too_large), do: "The file is too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
