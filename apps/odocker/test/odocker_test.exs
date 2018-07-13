defmodule ODockerTest do
  use ExUnit.Case
  doctest ODocker

  # HTTPoison.get! "http+unix://%2Fvar%2Frun%2Fdocker.sock/containers/json"

  test "get api version" do
    assert ODocker.api_version() == "1.37"
  end

  test "get containers" do
    {:ok, containers} = ODocker.containers()
    assert Enum.count(containers) == 2
    assert Enum.map(containers, fn container -> container["State"] end) == ["running", "running"]
  end

  test "get images" do
    {:ok, images} = ODocker.images()
    assert Enum.count(images) >= 2
  end

  test "delete not existing image" do
    {:error, error} = ODocker.delete_image("patata")
    assert error == %{"message" => "No such image: patata:latest"}
  end

  test "delete images" do
    result = ODocker.delete_images(fn image -> image["RepoTags"] != nil && Enum.any?(image["RepoTags"], fn tags -> String.starts_with?(tags, "ubuntu") end) end)
    assert result == "patata"
  end

  #test "pull a container" do
  #  result = ODocker.pull_image("ubuntu")
  #  assert result == "patata"    
  #end

  #test "create container" do
  #  result = ODocker.create_container("ubuntu")
  #  assert result == "patata"
  #end
end
