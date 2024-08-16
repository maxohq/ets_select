## v0.1.1 (2023-08-16)

- Add support for nested conditions, like:

```elixir
%{or: [[:=, :status, :new], %{and: [[:=, :status, :old], [:=, :age, 50]]}]}
```

## v0.1.0 (2023-08-16)

### First release

- Published on hex.pm