## v0.1.3 (2023-08-22)

- test files are not incluced in the Hex release (https://github.com/maxohq/ets_select/pull/1), thanks to @axelson!
- the req. Elixir version is now 1.15

## v0.1.2 (2023-08-16)

- Add support for a bit nicer syntax with implicit `==` handling:

```elixir
%{and: [%{status: :new}, %{age: 30}]}
```

## v0.1.1 (2023-08-16)

- Add support for nested conditions, like:

```elixir
%{or: [[:=, :status, :new], %{and: [[:=, :status, :old], [:=, :age, 50]]}]}
```

## v0.1.0 (2023-08-16)

### First release

- Published on hex.pm