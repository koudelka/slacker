Slacker
=======

Slacker's an Elixir bot library for [Slack](https://slack.com).

It has chat matching functionality built-in, but you can extend it to handle all kinds of [events](https://api.slack.com/events).

### Chat

Slacker can match regex or literal strings, then execute a given function (module optional).

```elixir
defmodule TARS do
  use Slacker
  use Slacker.Matcher
  
  match ~r/Sense of humor\. New level setting: ([0-9]+)%/, :set_humor
  match "Great idea. A massive, sarcastic robot.", [CueLight, :turn_on]

  def set_humor(tars, msg, level) do
    reply = "Sense of humor set to #{level}"
    say tars, msg["channel"], reply
  end
end
```

Slacker will call your function with the matching [message hash](https://api.slack.com/events/message). You can use `say/3` to respond, be sure to include the channel you want to talk to.

### Extending Slacker
Your robot is really just a `GenServer`, you can catch [RTM events](https://api.slack.com/events) from Slack and do whatever you like with them.

```elixir
defmodule CASE do
  use Slacker

  def handle_cast({:handle_incoming, "presence_change", msg}, state) do
    say self, msg["channel"], "You're the man who brought us the probe?"
    {:noreply, state}
  end

end
```

You can also use Slack's ["Web API"](https://api.slack.com/methods) via the `Slacker.Web` module. All of the available RPC methods are downcased and underscored.

`users.getPresence` -> `Slacker.Web.users_get_presence("your_api_key", user: "U1234567890")`

### Bootin' it up
Add this to your deps:

```elixir
def deps do
  [{:websocket_client, github: "jeremyong/websocket_client"},
  {:slacker,  "~> 0.0.3"}]
end
```

Create a [bot user](https://api.slack.com/bot-users) in the Slack GUI, and then pass your api token to your bot's `start_link/1`:

`{:ok, tars} = TARS.start_link("your_api_token")`

It's up to you to supervise your brand new baby bot.

You're going to need to invite your bot to a channel by `@`-mentioning them.

### Contributing
Gimme dem PR's.

Some of this stuff is a real pain in the ass to test, just do your best. :rocket:

TODO:
- Keep a map of usernames to ids.
- Keep a map of channel names to ids.
- Private messaging support.
- RTM tests.

## License

See the LICENSE file. (MIT)
