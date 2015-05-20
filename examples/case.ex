defmodule CASE do
  use Slacker

  def handle_cast({:handle_incoming, "presence_change", msg}, state) do
    say self, msg["channel"], "You're the man who brought us the probe?"
    {:noreply, state}
  end

end
