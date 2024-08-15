defmodule EtsSelect do
  def build(%{and: and_conditions}) do
    match_spec =
      Enum.reduce(and_conditions, %{}, fn [_, key, value], acc ->
        Map.put(acc, key, value)
      end)

    [{
      {:"$1", match_spec},
      [],
      [:"$_"]
    }]
  end

  def build(%{or: or_conditions}) do
    {match_head, guard, result} = build_or_condition(or_conditions)
    [{match_head, guard, result}]
  end

  defp build_or_condition(conditions) do
    {match_spec, guards} =
      Enum.reduce(conditions, {%{}, []}, fn [op, key, value], {match_spec, guards} ->
        var = :"$#{map_size(match_spec) + 2}"
        updated_match_spec = Map.put(match_spec, key, var)
        updated_guards = [{:orelse, {op, var, value}} | guards]
        {updated_match_spec, updated_guards}
      end)

    match_head = {:"$1", match_spec}
    guard = [List.foldr(guards, false, fn {_, guard}, acc -> {:orelse, guard, acc} end)]
    result = [:"$_"]

    {match_head, guard, result}
  end

  def build(simple_conditions) when is_map(simple_conditions) do
    conditions = Enum.map(simple_conditions, fn {k, v} -> [:=, k, v] end)
    build(%{and: conditions})
  end
end
