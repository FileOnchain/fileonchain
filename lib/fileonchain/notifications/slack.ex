defmodule Fileonchain.Notifications.Slack do
  use HTTPoison.Base

  @base_url "https://slack.com/api/chat.postMessage"

  def send_message(message) do
    body = Jason.encode!(%{
      channel: System.get_env("SLACK_CHANNEL"),
      text: message
    })

    headers = [
      {"Authorization", "Bearer #{System.get_env("SLACK_API_TOKEN")}"},
      {"Content-Type", "application/json"}
    ]

    case post(@base_url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
