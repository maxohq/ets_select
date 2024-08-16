# EtsSelect
A very simple and very useful little package to help you write non-trivial ETS match specs without fighting with the docs - [Match Specifications in Erlang](https://www.erlang.org/doc/apps/erts/match_spec.html).


No macros, no huge ambitions, just a simple 50-lines long Elixir module. You use a simple and very familiar query syntax and get efficient ETS match specs to filter out your rows from ETS tables.

Assumptions / Limitations:
- you store your data in maps / structs and look it up by a key
- you select rows from simple flat maps (no support for nesting attributes) - YET

## Example:

```elixir
:ets.new(:my_table, [:set, :public, :named_table])

:ets.insert(:my_table, {:key1, %{status: :new, age: 30, name: "1", nested: %{a: 1}}})
:ets.insert(:my_table, {:key2, %{status: :old, age: 25, name: "2"}})
:ets.insert(:my_table, {:key3, %{status: :middle, age: 35, name: "3"}})
:ets.insert(:my_table, {:key4, %{status: :ancient, age: 100, name: "4"}})
:ets.insert(:my_table, {:key5, %{status: :old, age: 50, name: "5"}})

## find all items with status = :new or status = :old
query = %{or: [[:=, :status, :new], [:=, :status, :old]]}
match_spec = EtsSelect.build(query)
:ets.select(:my_table, match_spec)
#=> returns 1,2,5


query = %{and: [[:=, :status, :old], [:>, :age, 30]]}
match_spec = EtsSelect.build(query)
:ets.select(:my_table, match_spec)
#=> returns 5


query = %{age: 30}
match_spec = EtsSelect.build(query)
:ets.select(:my_table, match_spec)
#=> returns 1
```


## Are there any other alternatives?

I have looked at [matcha](https://hex.pm/packages/matcha) + [Matcha - first-class match specifications for Elixir](https://elixirforum.com/t/matcha-first-class-match-specifications-for-elixir/52182).

The package has a lot of code and the test suite has some failures. It has much more features, but feels also not quite complete and too complex for my needs.

There is also [match_spec](https://hexdocs.pm/match_spec/MatchSpec.html). But it uses macros that transforms elixir-style function into match specs. Not quite what I need. (https://elixirforum.com/t/matchspec-library-for-transforming-ets-matchspecs/52698/1)

I also saw [ex2ms](https://github.com/ericmj/ex2ms/tree/main), it has a great test suite and is quite small. But again: macros + elixir-style functions.


Then there is [active_memory](https://github.com/SullysMustyRuby/active_memory), but it is much more full-featured and handles also queries on Mnesia. I liked it, but felt it could constrain me with some assumpions.

[Etso](https://github.com/evadne/etso) requires Ecto, that is a bit too much for my needs.


## Summary

So there you have it. It is a single module, that can be quickly vendored, adjusted or fixed. It wont break with any new Elixir versions and wont cause you any further headache.


Enjoy! 😎

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ets_select` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ets_select, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ets_select>.

