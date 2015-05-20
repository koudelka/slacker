defmodule Slacker.WebAPI do
  use HTTPoison.Base

  @url_base Application.get_env(:slacker, :url_base) || "https://slack.com/api/"

  def post(path, body) do
    path
    |> super(body)
    |> check_response
  end

  defp process_url(path) do
    @url_base <> path
  end

  defp process_response_body(body) do
    body
    |> Poison.decode!
    |> Enum.reduce(%{}, fn {k, v}, map -> Dict.put(map, String.to_atom(k), v) end)
  end

  defp check_response({:ok, %{status_code: 200, body: %{ok: true} = body}}) do
    {:ok, body}
  end
  defp check_response({_, response}), do: {:error, response}
end
