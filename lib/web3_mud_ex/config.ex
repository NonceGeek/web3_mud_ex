defmodule Web3MUDEx.Config do
  @moduledoc """
  Load configuration for the application

  Split out into application specific config, ecto database config,
  and phoenix endpoint config.
  """

  alias Web3MUDEx.Config.Cache
  alias Vapor.Provider.Dotenv
  alias Vapor.Provider.Env

  defdelegate deploy_env(), to: Cache

  @doc """
  Load and parse application configuration
  """
  def application() do
    Vapor.load!(application_providers())
  end

  # Fill this in:
  defp application_providers() do
    [
      %Dotenv{},
      %Env{
        bindings: [
          {:deploy_env, "DEPLOY_ENV"}
        ]
      }
    ]
  end

  @doc """
  Load and parse database configuration
  """
  def database() do
    Vapor.load!(database_providers())
  end

  defp database_providers() do
    [
      %Dotenv{},
      %Env{
        bindings: [
          {:database_url, "DATABASE_URL"},
          {:pool_size, "POOL_SIZE", map: &String.to_integer/1}
        ]
      }
    ]
  end

  @doc """
  Load and parse endpoint configuration
  """
  def endpoint() do
    Vapor.load!(endpoint_providers())
  end

  defp endpoint_providers() do
    [
      %Dotenv{},
      %Env{
        bindings: [
          {:http_port, "PORT", map: &String.to_integer/1},
          {:secret_key_base, "SECRET_KEY_BASE"},
          {:url_host, "HOST"},
          {:url_port, "URL_PORT", map: &String.to_integer/1},
          {:url_scheme, "URL_SCHEME"}
        ]
      }
    ]
  end
end

defmodule Web3MUDEx.Config.Cache do
  @moduledoc """
  Create persistent terms for application configuration
  """

  use GenServer

  alias Web3MUDEx.Config

  def deploy_env(), do: :persistent_term.get({__MODULE__, :deploy_env})

  @doc false
  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  @impl true
  def init(_) do
    {:ok, %{}, {:continue, :set}}
  end

  @impl true
  def handle_continue(:set, state) do
    Enum.each(Config.application(), fn {key, value} ->
      :persistent_term.put({__MODULE__, key}, value)
    end)

    {:noreply, state}
  end
end
