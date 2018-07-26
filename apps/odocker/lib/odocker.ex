defmodule ODocker do
  require Logger

  @url "http+unix://%2Fvar%2Frun%2Fdocker.sock"

  @moduledoc """
  Documentation for ODocker.
  """

  @doc """
  Get containers
  """
  def containers do
    HTTPoison.get!(@url <> "/containers/json") |> decode_from_body
  end

  def images do
    HTTPoison.get!(@url <> "/images/json") |> decode_from_body
  end

  def api_version do
    HTTPoison.get!(@url <> "/containers/json") |> extract_api_version
  end

  def pull_image(image) do
    HTTPoison.post!(@url <> "/images/create?fromImage=" <> image, "") |> result_by_status_code(image)
  end

  def delete_image(image) do
    HTTPoison.delete!(@url <> "/images/" <> image <> "?force=true") |> result_and_body
  end

  def delete_images(function) do
    {:ok, list_images} = images
    list_images |> Enum.filter(function) |> Enum.map(fn image -> delete_image(image["Id"]) end)
  end

  def create_container(image) do
    HTTPoison.post!(
      @url <> "/containers/create", 
      Poison.encode!(%{"Image" => image}),
      [{"Content-Type", "application/json"}]
    ) |> result_and_body
  end

  defp decode_from_body(%HTTPoison.Response{body: body}) do
    case Poison.decode(body) do
      {:ok, dict} -> {:ok, dict}
      {:error, _} -> {:error, :decoding}
    end
  end

  defp containers_from_body(error) do
    Logger.error "Error response: #{inspect error}"
    {:error, :connection}
  end

  defp extract_api_version(%HTTPoison.Response{headers: headers}) do
    Enum.find(headers, fn header -> elem(header, 0) == "Api-Version" end) |> elem(1)
  end

  defp result_and_body(response) do
    result_by_status_code(response, Poison.decode!(response.body))
  end

  defp result_by_status_code(response, result) do
    case response.status_code do
      200 -> {:ok, result}
      201 -> {:ok, result}
      _ -> {:error, result}
    end
  end
end
