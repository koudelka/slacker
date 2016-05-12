defmodule Slacker.MatcherTest do
  use ExUnit.Case

  defmodule Test do
    use Slacker.Matcher

    match "hi", :say_hi
    match "hello", :say_hello
    match ~r/say hi to robot #([0-9]+)/, :say_hello
    match ~r/say bye to robot #([0-9]+)/, :say_goodbye

    def say_hi(pid, msg, _state) do
      send pid, "#{msg["text"]} there"
    end

    def say_hello(pid, msg, _state) do
      send pid, "#{msg["text"]} again"
    end

    def say_hello(pid, _msg, robot_number, _state) do
      send pid, "hello, robot #{robot_number}"
    end

    def say_goodbye(pid, _msg, robot_number, _state) do
      send pid, "bye, robot #{robot_number}"
    end
  end

  test "match!/2 matches strings" do
    Test.match!(self, %{"text" => "hi"}, %{})
    assert_receive "hi there"

    Test.match!(self, %{"text" => "hello"}, %{})
    assert_receive "hello again"
  end

  test "match!/3 matches regexes" do
    Test.match!(self, %{"text" => "say hi to robot #123"}, %{})
    assert_receive "hello, robot 123"

    Test.match!(self, %{"text" => "say bye to robot #123"}, %{})
    assert_receive "bye, robot 123"
  end
end
