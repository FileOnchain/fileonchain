defmodule FileonchainWeb.UserLoginLive do
  use FileonchainWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-md p-12 bg-gray-900 text-white rounded-lg shadow-lg">
      <.header class="text-center text-white text-2xl">
        Log in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline text-blue-400">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore" class="space-y-6 bg-gray-900">
        <.input field={@form[:email]} type="email" label="Email" required class="w-full p-4 border border-gray-700 rounded bg-gray-800 text-white" />
        <.input field={@form[:password]} type="password" label="Password" required class="w-full p-4 border border-gray-700 rounded bg-gray-800 text-white" />

        <:actions>
          <div class="flex flex-col space-y-2">
            <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" class="text-white" />
            <.link href={~p"/users/reset_password"} class="text-sm font-semibold text-blue-400">
              Forgot your password?
            </.link>
          </div>
        </:actions>
        <:actions>
          <.button phx-disable-with="Logging in..." class="w-full bg-blue-500 text-white p-4 rounded hover:bg-blue-600">
            Log in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
