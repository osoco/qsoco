# odocker

Use Docker from Elixir. Just started...

https://osoco.github.io/qsoco/odocker.html

Available at dockerhub (jorgeosoco/odocker)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `odocker` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:odocker, "~> 0.1.0"}
  ]
end
```

## Build

Generate odocker executable: > mix escript.build

Generate image with erlang and odocker executable (using Dockerfile): > docker build -t osoco/odocker .

Start container as daemon: > docker run -d -v /var/run/docker.sock:/var/run/docker.sock --name odocker osoco/odocker tail -f /dev/null

Execute odocker in the container: > docker exec odocker ./odocker [params]

## Release

Generate a release and publish in docker hub (jorgeosoco/odocker):

./release.sh <version>

## Info

Example to get images list: curl --unix-socket /var/run/docker.sock http:/v1.24/images/json

Access docker api from container: https://forums.docker.com/t/how-can-i-run-docker-command-inside-a-docker-container/337

Some interesanting links developing...

https://github.com/devinus/poison

https://hexdocs.pm/httpoison/HTTPoison.html

https://github.com/edgurgel/httpoison

https://docs.docker.com/engine/api/v1.37/

https://docs.docker.com/develop/sdk/examples/

