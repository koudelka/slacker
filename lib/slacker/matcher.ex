defmodule Slacker.Matcher do

  defmacro __using__(_opts) do
    quote do
      @regex_patterns []
      Module.register_attribute(__MODULE__, :regex_patterns, accumulate: true)

      import unquote(__MODULE__), only: [match: 2]

      @before_compile unquote(__MODULE__)


      # some integrations don't provide a "text" field, ignore them
      def handle_cast({:handle_incoming, "message", %{"text" => _} = msg}, state) do
        match!(self, msg)
        {:noreply, state}
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def match!(slacker, %{"text" => text} = msg) do
        Enum.each(@regex_patterns, fn {pattern, [m, f]} ->
          match = Regex.run(pattern, text)
          if match do
            [_text | captures] = match
            :erlang.apply(m, f, [slacker, msg] ++ captures)
          end
        end)
      end
    end
  end

  defmacro match(pattern, function) do
    {function, []} = Code.eval_quoted(function, [], __ENV__)
    [m, f] = case function do
               f when is_atom(f) -> [__CALLER__.module, f]
               [m, f] -> [m, f]
             end

    quote do
      if is_binary(unquote(pattern)) do
        def match!(slacker, %{"text" => unquote(pattern)} = msg) do
          :erlang.apply(unquote(m), unquote(f), [slacker, msg])
        end
      else
        @regex_patterns {unquote(pattern), [unquote(m), unquote(f)]}
      end
    end
  end

end
