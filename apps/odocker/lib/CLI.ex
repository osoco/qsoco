defmodule ODocker.CLI do
  # use Application

  def main(args \\ []) do
    process_arguments(args)
  end

  def version do
    {result, text} = File.read("version")
    case result do
      :ok -> text
      :error -> "(no version)"
    end
  end

  defp process_arguments(["help" | _rest]) do
    IO.puts "ODocker version: " <> ODocker.CLI.version
    IO.puts "Docker api running in your system: " <> ODocker.api_version()
    IO.puts ""
    IO.puts "Available commands:"
    IO.puts "    help                this command"
    IO.puts "    autoClean           remove odocker container and image"
    IO.puts "    cleanContainers     remove all containers"
    IO.puts "    cleanImages         remove all images"
    IO.puts "    cleanAll            remove all containers and images"
  end

  defp process_arguments(["cleanContainers" | _rest]) do
    ODocker.delete_all_containers
  end

  defp process_arguments(["cleanImages" | _rest]) do
    ODocker.delete_all_images
  end

  defp process_arguments(["cleanAll" | _rest]) do
    ODocker.delete_all_containers
    ODocker.delete_all_images
  end

  defp process_arguments(_any) do
    IO.puts "Get info with: odocker help"
  end
end
