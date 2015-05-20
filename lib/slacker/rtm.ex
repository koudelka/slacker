defmodule Slacker.RTM do
  require Logger

  @behaviour :websocket_client_handler

  def start_link(url, slacker_pid) do
    :websocket_client.start_link(url, __MODULE__, slacker_pid)
  end

  def init(slacker_pid, _conn_state) do
    {:ok, slacker_pid}
  end

  def websocket_handle({:text, msg}, _conn_state, slacker_pid) do
    {type, msg} =
      Poison.decode!(msg)
      |> Dict.pop("type")

    GenServer.cast(slacker_pid, {:handle_incoming, type, msg})

    {:ok, slacker_pid}
  end

  def websocket_handle({:ping, _msg}, _conn_state, state) do
    {:ok, state}
  end

  def websocket_info({_gen_type, {:send_message, channel, msg}}, _conn_state, state) do
    reply = %{id: 1,
              type: :message,
              channel: channel,
              text: msg
            } |> Poison.encode!

    {:reply, {:text, reply}, state}
  end

  def websocket_info(msg, _conn_state, state) do
    Logger.info "ignoring: #{inspect msg}"
    {:ok, state}
  end

  def websocket_terminate(_msg, _conn_state, _state) do
    Logger.debug "websocket closed"
    :ok
  end
end
