defmodule EtsSelectTest do
  use ExUnit.Case
  use Mneme

  test "build with OR conditions" do
    query = %{or: [[:=, :status, :new], [:=, :status, :old]]}

    auto_assert(
      [{{:"$1", %{status: :"$2"}}, [{:orelse, {:==, :"$2", :new}, {:==, :"$2", :old}}], [:"$_"]}] <-
        EtsSelect.build(query)
    )
  end

  test "build with AND conditions" do
    query = %{and: [[:=, :status, :new], [:=, :age, 30]]}

    auto_assert(
      [
        {{:"$1", %{age: :"$3", status: :"$2"}},
         [{:andalso, {:==, :"$2", :new}, {:==, :"$3", 30}}], [:"$_"]}
      ] <- EtsSelect.build(query)
    )
  end

  test "build with complex OR conditions" do
    query = %{or: [[:=, :status, :new], [:=, :status, :old], [:=, :age, 35]]}

    auto_assert(
      [
        {{:"$1", %{age: :"$3", status: :"$2"}},
         [{:orelse, {:orelse, {:==, :"$2", :new}, {:==, :"$2", :old}}, {:==, :"$3", 35}}],
         [:"$_"]}
      ] <- EtsSelect.build(query)
    )
  end

  test "build with complex AND conditions" do
    query = %{and: [[:=, :status, :new], [:<, :age, 100], [:>, :age, 30]]}

    auto_assert(
      [
        {{:"$1", %{age: :"$3", status: :"$2"}},
         [{:andalso, {:andalso, {:==, :"$2", :new}, {:<, :"$3", 100}}, {:>, :"$3", 30}}], [:"$_"]}
      ] <- EtsSelect.build(query)
    )
  end

  test "build with simple conditions" do
    query = %{age: 30, name: "Bob"}

    auto_assert(
      [
        {{:"$1", %{age: :"$3", name: :"$2"}}, [{:andalso, {:==, :"$2", "Bob"}, {:==, :"$3", 30}}],
         [:"$_"]}
      ] <- EtsSelect.build(query)
    )
  end

  test "build with OR conditions and project" do
    query = %{or: [[:=, :status, :new], [:=, :status, :old]], project: [:key, :status]}

    auto_assert(
      [
        {{:"$1", %{status: :"$2"}}, [{:orelse, {:==, :"$2", :new}, {:==, :"$2", :old}}],
         nil: :"$2"}
      ] <- EtsSelect.build(query)
    )
  end

  test "build with AND conditions and project" do
    query = %{and: [[:>, :age, 30], [:>, :name, "Eve"]], project: [:name, :age]}

    auto_assert(
      [
        {{:"$1", %{age: :"$2", name: :"$3"}}, [{:andalso, {:>, :"$2", 30}, {:>, :"$3", "Eve"}}],
         "$3": :"$2"}
      ] <- EtsSelect.build(query)
    )
  end
end
