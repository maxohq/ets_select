defmodule EtsSelect do
  def build(%{and: and_conditions}) do
  end

  def build(%{or: or_conditions}) do
  end

  def build(simple_conditions) do
    list = Enum.map(simple_conditions, fn {k, v} -> Map.new([{k, v}]) end)
    build(%{and: list})
  end
end
