defmodule EtsSelectTest do
  use ExUnit.Case

  test "build with OR conditions" do
    query = %{or: [[:=, :status, :new], [:=, :status, :old]]}
    expected = [
      {
        {:"$1", %{status: :"$2"}},
        [{:orelse, {:=, :"$2", :new}, {:=, :"$2", :old}}],
        [:"$_"]
      }
    ]
    assert EtsSelect.build(query) == expected
  end

  test "build with complex OR conditions" do
    query = %{or: [[:=, :age, 30], [:=, :age, 35], [:=, :name, "Bob"]]}
    expected = [
      {
        {:"$1", %{age: :"$2", name: :"$3"}},
        [{:orelse, {:==, :"$2", 30}, {:orelse, {:==, :"$2", 35}, {:==, :"$3", "Bob"}}}],
        [:"$_"]
      }
    ]
    assert EtsSelect.build(query) == expected
  end

  test "build with AND conditions" do
    query = %{and: [[:>, :age, 30], [:>, :name, "Eve"]]}
    expected = [
      {
        {:"$1", %{age: :"$2", name: :"$3"}},
        [{:andalso, {:>, :"$2", 30}, {:>, :"$3", "Eve"}}],
        [:"$_"]
      }
    ]
    assert EtsSelect.build(query) == expected
  end

  test "build with simple conditions" do
    query = %{age: 30, name: "Bob"}
    expected = [
      {
        {:"$1", %{age: :"$2", name: :"$3"}},
        [{:andalso, {:==, :"$2", 30}, {:==, :"$3", "Bob"}}],
        [:"$_"]
      }
    ]
    assert EtsSelect.build(query) == expected
  end
end
