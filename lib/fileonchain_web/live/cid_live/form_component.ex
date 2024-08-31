defmodule FileonchainWeb.CidLive.FormComponent do
  use FileonchainWeb, :live_component

  alias Fileonchain.Cids

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage cid records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="cid-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:cid]} type="text" label="Cid" />
        <.input field={@form[:data]} type="text" label="Data" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Cid</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{cid: cid} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Cids.change_cid(cid))
     end)}
  end

  @impl true
  def handle_event("validate", %{"cid" => cid_params}, socket) do
    changeset = Cids.change_cid(socket.assigns.cid, cid_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"cid" => cid_params}, socket) do
    save_cid(socket, socket.assigns.action, cid_params)
  end

  defp save_cid(socket, :edit, cid_params) do
    case Cids.update_cid(socket.assigns.cid, cid_params) do
      {:ok, cid} ->
        notify_parent({:saved, cid})

        {:noreply,
         socket
         |> put_flash(:info, "Cid updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_cid(socket, :new, cid_params) do
    case Cids.create_cid(cid_params) do
      {:ok, cid} ->
        notify_parent({:saved, cid})

        {:noreply,
         socket
         |> put_flash(:info, "Cid created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
