defmodule Slacker.Web do
  # @moduledoc ~S"""
  #   Slacker.Web is your interface to Slack's "Web API", https://api.slack.com/web

  #   You can call any of the Web API methods on this module as their underscored name
  #   and provide any necessary parameters as a keyword list, ex:

  #     https://api.slack.com/methods/channels.setPurpose
  #     Slacker.Web.channels_set_purpose(channel: "general", purpose: "let's waste time")

  #   Your auth token will be automatically included for you.
  # """

  alias Slacker.WebAPI

  # https://api.slack.com/methods
  @methods [
    "api.test",
    "auth.test",
    "channels.archive",
    "channels.create",
    "channels.history",
    "channels.info",
    "channels.invite",
    "channels.join",
    "channels.kick",
    "channels.leave",
    "channels.list",
    "channels.mark",
    "channels.rename",
    "channels.setPurpose",
    "channels.setTopic",
    "channels.unarchive",
    "chat.delete",
    "chat.postMessage",
    "chat.update",
    "emoji.list",
    "files.delete",
    "files.info",
    "files.list",
    "files.upload",
    "groups.archive",
    "groups.close",
    "groups.create",
    "groups.createChild",
    "groups.history",
    "groups.info",
    "groups.invite",
    "groups.kick",
    "groups.leave",
    "groups.list",
    "groups.mark",
    "groups.open",
    "groups.rename",
    "groups.setPurpose",
    "groups.setTopic",
    "groups.unarchive",
    "im.close",
    "im.history",
    "im.list",
    "im.mark",
    "im.open",
    "oauth.access",
    "rtm.start",
    "search.all",
    "search.files",
    "search.messages",
    "stars.list",
    "team.accessLogs",
    "team.info",
    "users.getPresence",
    "users.info",
    "users.list",
    "users.setActive",
    "users.setPresence",
  ]

  Enum.each(@methods, fn(api_method) ->
    method = api_method |> String.replace(".", "_") |> Inflex.underscore

    def unquote(String.to_atom method)(api_token, params \\ []) do
      body = params
      |> Keyword.put(:token, api_token)

      # {:form, body} is a hackney expression
      WebAPI.post(unquote(api_method), {:form, body})
    end
  end)
end
