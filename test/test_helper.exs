defmodule Slacker.TestServer do
  use GenServer
  alias Slacker.TestServer.HTTP

  defmodule State do
    defstruct test_pid: nil, http_pid: nil, response: nil
  end

  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, http} = HTTP.start(self)
    {:ok, %State{http_pid: http}}
  end

  def respond_with(pid, response, test_pid \\ self) do
    GenServer.call(pid, {:respond_with, response, test_pid})
  end


  def handle_call({:respond_with, response, test_pid}, _from, state) do
    {:reply, :ok, %{state | response: response, test_pid: test_pid}}
  end

  def handle_call(:response, _from, %{response: response} = state) do
    {:reply, response, %{state | response: nil}}
  end

  def handle_cast({:respond, conn}, %{test_pid: test_pid} = state) do
    send test_pid, conn
    {:noreply, %{state | test_pid: nil}}
  end

  def stop(pid) do
    Process.exit(pid, :kill)
  end

  def terminate(_reason, _state) do
    HTTP.stop
    :ok
  end

  defmodule HTTP do
    use Plug.Builder

    plug Plug.Parsers, parsers: [:urlencoded]

    def init(test_server) do
      test_server
    end

    def call(conn, test_server) do
      {status, body} = GenServer.call(test_server, :response)

      conn = super(conn, [])
      |> fetch_cookies
      |> fetch_query_params
      |> resp(status, body)

      GenServer.cast(test_server, {:respond, conn})

      conn
    end

    def start(test_server) do
      Plug.Adapters.Cowboy.http __MODULE__, test_server
    end

    def stop do
      Plug.Adapters.Cowboy.shutdown __MODULE__
    end
  end
end

ExUnit.start()
