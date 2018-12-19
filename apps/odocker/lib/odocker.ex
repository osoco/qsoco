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

  def all_containers do
    HTTPoison.get!(@url <> "/containers/json" <> "?all=true") |> decode_from_body
  end

  def delete_all_containers do
    {:ok, containers} = ODocker.all_containers
    unless containers == [] do
        containers
          |> Enum.map(fn container -> container["Names"] end)
          |> List.flatten
          |> Enum.map(fn name -> ODocker.delete_container(name) end)
    end
  end

  def delete_all_images do
    {:ok, images} = ODocker.all_images()
    unless images == [] do
        images
          |> Enum.map(fn image -> image["Id"] end)
          |> Enum.map(fn id -> ODocker.delete_image(id) end)
    end
  end

  def all_images do
    HTTPoison.get!(@url <> "/images/json" <> "?all=true") |> decode_from_body
  end

  def images do
    HTTPoison.get!(@url <> "/images/json") |> decode_from_body
  end

  def api_version do
    HTTPoison.get!(@url <> "/containers/json") |> extract_api_version
  end

  def pull_image(image) do
    HTTPoison.post!(@url <> "/images/create?fromImage=" <> image, 
      [], [timeout: 50_000, recv_timeout: 50_000]) 
    |> result_by_status_code(image)
  end

  def delete_image(id) do
    HTTPoison.delete!(@url <> "/images/" <> id <> "?force=true") |> result_and_body
  end

  def delete_container("/" <> name) do
    delete_container(name)
  end

  def delete_container(name) do
    HTTPoison.delete!(@url <> "/containers/" <> name <> "?force=true") |> result
  end

  def delete_images(function) do
    {:ok, list_images} = ODocker.images
    list_images |> Enum.filter(function) |> Enum.map(fn image -> delete_image(image["Id"]) end)
  end

  def create_container(image, command \\ []) do
    params = case command do
      [] -> %{"Image" => image}
      _ -> %{"Image" => image, "Cmd" => command}
    end
    HTTPoison.post!(
      @url <> "/containers/create", 
      Poison.encode!(params),
      [{"Content-Type", "application/json"}]
    ) |> result_and_body
  end

  defp decode_from_body(%HTTPoison.Response{body: body}) do
    case Poison.decode(body) do
      {:ok, dict} -> {:ok, dict}
      {:error, _} -> {:error, :decoding}
    end
  end

  defp extract_api_version(%HTTPoison.Response{headers: headers}) do
    Enum.find(headers, fn header -> elem(header, 0) == "Api-Version" end) |> elem(1)
  end

  defp result(response) do
    result_by_status_code(response, %{})
  end

  defp result_and_body(response) do
    result_by_status_code(response, Poison.decode!(response.body))
  end

  defp result_by_status_code(response, result) do
    case response.status_code do
      200 -> {:ok, result}
      201 -> {:ok, result}
      202 -> {:ok, result}
      203 -> {:ok, result}
      204 -> {:ok, result}
      _ -> {:error, result}
    end
  end
end
