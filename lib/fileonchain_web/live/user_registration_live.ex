defmodule FileonchainWeb.UserRegistrationLive do
  use FileonchainWeb, :live_view
  require Logger

  alias Fileonchain.Accounts
  alias Fileonchain.Accounts.User
  alias Fileonchain.Notifications.Slack

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-md p-12 bg-gray-900 text-white rounded-lg shadow-lg">
      <.header class="text-center text-white text-2xl">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline text-blue-400">
            Log in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
        class="space-y-6 bg-gray-900"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:email]} type="email" label="Email" required class="w-full p-4 border border-gray-700 rounded bg-gray-800 text-white" />
        <.input field={@form[:password]} type="password" label="Password" required class="w-full p-4 border border-gray-700 rounded bg-gray-800 text-white" />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full bg-blue-500 text-white p-4 rounded hover:bg-blue-600">
            Create an account
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    Logger.info("Attempting to register new user with params: #{inspect(user_params)}")
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        Logger.info("User registered successfully: #{user.email}")
        # {:ok, _} =
          # Accounts.deliver_user_confirmation_instructions(
          #  user,
          #  &url(~p"/users/confirm/#{&1}")
        #  )

        # Send Slack notification
        case Slack.send_message("New user registered: #{user.email}") do
          {:ok, _} ->
            Logger.info("Slack notification sent for new user: #{user.email}")
            :ok
          {:error, reason} ->
            # Log the error, but don't interrupt the user registration process
            Logger.error("Failed to send Slack notification: #{inspect(reason)}")
        end

        changeset = Accounts.change_user_registration(user)
        Logger.info("User registration process completed for: #{user.email}")
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.warning("User registration failed: #{inspect(changeset.errors)}")
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
