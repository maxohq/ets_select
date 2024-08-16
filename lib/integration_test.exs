defmodule EtsSelect.IntegrationTest do
  use ExUnit.Case
  use Mneme

  setup do
    :ets.new(:my_table, [:set, :public, :named_table])

    :ets.insert(:my_table, {:key1, %{status: :new, age: 30, name: "1"}})
    :ets.insert(:my_table, {:key2, %{status: :old, age: 25, name: "2"}})
    :ets.insert(:my_table, {:key3, %{status: :middle, age: 35, name: "3"}})
    :ets.insert(:my_table, {:key4, %{status: :ancient, age: 100, name: "4"}})
    :ets.insert(:my_table, {:key5, %{status: :old, age: 50, name: "5"}})

    :ok
  end

  def check(query) do
    match_spec = EtsSelect.build(query)
    :ets.select(:my_table, match_spec)
  end

  test "OR: simple" do
    q = %{or: [[:=, :status, :new], [:=, :status, :old]]}

    auto_assert(
      [
        key5: %{age: 50, status: :old},
        key2: %{age: 25, status: :old},
        key1: %{age: 30, status: :new}
      ] <- check(q)
    )
  end

  test "AND: simple" do
    q = %{and: [[:=, :status, :old], [:<, :age, 30]]}
    auto_assert([key2: %{age: 25, status: :old}] <- check(q))
  end

  test "AND: multiple" do
    q = %{and: [[:=, :status, :old], [:>, :age, 20], [:<, :age, 51]]}
    auto_assert([key5: %{age: 50, status: :old}, key2: %{age: 25, status: :old}] <- check(q))
  end

  test "OR: multiple" do
    q = %{or: [[:=, :status, :old], [:=, :status, :new], [:>, :age, 50]]}

    auto_assert(
      [
        key5: %{age: 50, status: :old},
        key4: %{age: 100, status: :ancient},
        key2: %{age: 25, status: :old},
        key1: %{age: 30, status: :new}
      ] <- check(q)
    )
  end

  test "simplistic / implicit AND" do
    q = %{status: :new, age: 30}
    auto_assert([key1: %{age: 30, name: "1", status: :new}] <- check(q))
  end

  test "nested  and / or conditions" do
    q = %{or: [[:=, :status, :new], %{and: [[:=, :status, :old], [:=, :age, 50]]}]}

    auto_assert(
      [key5: %{age: 50, name: "5", status: :old}, key1: %{age: 30, name: "1", status: :new}] <-
        check(q)
    )
  end
end
