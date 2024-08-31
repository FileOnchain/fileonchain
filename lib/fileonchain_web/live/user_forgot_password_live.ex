defmodule FileonchainWeb.UserForgotPasswordLive do
  use FileonchainWeb, :live_view

  alias Fileonchain.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-md p-12 bg-gray-900 text-white rounded-lg shadow-lg">
      <.header class="text-center text-white text-2xl">
        Forgot your password?
        <:subtitle>
          We'll send a password reset link to your inbox.
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="reset_password_form" phx-submit="send_email" class="space-y-6 bg-gray-900">
        <.input field={@form[:email]} type="email" placeholder="Email" required class="w-full p-4 border border-gray-700 rounded bg-gray-800 text-white" />
        <:actions>
          <.button phx-disable-with="Sending..." class="w-full bg-blue-500 text-white p-4 rounded hover:bg-blue-600">
            Send password reset instructions
          </.button>
        </:actions>
      </.simple_form>
      <p class="text-center text-sm mt-4">
        <.link href={~p"/users/register"} class="font-semibold text-blue-400 hover:underline">Register</.link>
        | <.link href={~p"/users/log_in"} class="font-semibold text-blue-400 hover:underline">Log in</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
