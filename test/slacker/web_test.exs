defmodule Slacker.WebTest do
  use ExUnit.Case, async: false # the TestServer is serial
  alias Slacker.Web
  alias Slacker.TestServer

  setup_all do
    {:ok, server} = TestServer.start_link

    on_exit fn ->
      TestServer.stop server
    end

    {:ok, server: server}
  end

  test "adds the api token into the request params", %{server: server} do
    TestServer.respond_with(server, {200, "{}"})

    Web.api_test("abcdef", a: 1, b: 2)

    assert_receive %{method: "POST", body_params: %{"token" => "abcdef", "a" => "1", "b" => "2"}}
  end

  test "decodes JSON responses when response is 'ok'", %{server: server} do
    TestServer.respond_with(server, {200, ~s|{"ok" : true, "hi": "there"}|})

    response = Web.api_test("apitoken", a: 1, b: 2)

    assert response == {:ok, %{hi: "there", ok: true}}
  end

  test "decodes JSON response with raw response when not 'ok'", %{server: server} do
    TestServer.respond_with(server, {200, ~s|{"ok" : false, "hi": "there"}|})

    response = Web.api_test("apitoken", a: 1, b: 2)

    assert {:error, %{body: %{hi: "there", ok: false}}} = response
  end

  test "gives raw response when there's an 'error'", %{server: server} do
    TestServer.respond_with(server, {404, ~s|{"hi": "there"}|})

    response = Web.api_test("apitoken", a: 1, b: 2)

    assert {:error, %{body: %{hi: "there"}, status_code: 404}} = response
  end
end
