defmodule EtsSelectTest do
  use ExUnit.Case

  test "build with OR conditions" do
    query = %{or: [[:=, :status, :new], [:=, :status, :old]]}
    expected = [
      {
        {:"$1", %{status: :"$2"}},
        [{:orelse, {:==, :"$2", :new}, {:==, :"$2", :old}}],
        [:"$_"]
      }
    ]
    assert EtsSelect.build(query) == expected
  end

  test "build with complex OR conditions" do
    query = %{or: [[:=, :age, 30], [:=, :age, 35], [:=, :name, "Bob"]]}
    expected = [
      {
        {:"$1", %{name: :"$2", age: :"$3"}},
        [{:orelse,
          {:==, :"$3", 30},
          {:orelse,
            {:==, :"$3", 35},
            {:==, :"$2", "Bob"}
          }}],
        [:"$_"]
      }
    ]
    assert EtsSelect.build(query) == expected
  end

  test "build with AND conditions" do
    query = %{and: [[:=, :age, 30], [:=, :name, "Bob"]]}
    expected = [
      {
        {:"$1", %{age: 30, name: "Bob"}},
        [],
        [:"$_"]
      }
    ]
    assert EtsSelect.build(query) == expected
  end

  test "build with simple conditions" do
    query = %{age: 30, name: "Bob"}
    expected = [
      {
        {:"$1", %{age: 30, name: "Bob"}},
        [],
        [:"$_"]
      }
    ]
    assert EtsSelect.build(query) == expected
  end
end
