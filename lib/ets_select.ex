defmodule EtsSelect do
  def build(%{and: and_conditions, project: project}) do
    build_condition(:and, and_conditions, project)
  end

  def build(%{or: or_conditions, project: project}) do
    build_condition(:or, or_conditions, project)
  end

  def build(%{and: and_conditions}), do: build(%{and: and_conditions, project: nil})
  def build(%{or: or_conditions}), do: build(%{or: or_conditions, project: nil})

  def build(simple_conditions) when is_map(simple_conditions) do
    conditions = Enum.map(simple_conditions, fn {k, v} -> [:=, k, v] end)
    build(%{and: conditions})
  end

  defp build_condition(type, conditions, project) do
    {match_spec, guards} = Enum.reduce(conditions, {%{}, []}, &handle_condition/2)
    match_head = {:"$1", match_spec}
    guard = [build_guard(type, Enum.reverse(guards))]
    result = build_project(match_spec, project)

    [{match_head, guard, result}]
  end

  defp handle_condition([op, key, value], {match_spec, guards}) do
    var = Map.get(match_spec, key, :"$#{map_size(match_spec) + 2}")
    updated_match_spec = Map.put(match_spec, key, var)
    updated_guards = [{translate_op(op), var, value} | guards]
    {updated_match_spec, updated_guards}
  end

  defp handle_condition(%{and: nested_conditions}, {match_spec, guards}) do
    {updated_match_spec, nested_guards} = Enum.reduce(nested_conditions, {match_spec, []}, &handle_condition/2)
    {updated_match_spec, [build_guard(:and, nested_guards) | guards]}
  end

  defp handle_condition(%{or: nested_conditions}, {match_spec, guards}) do
    {updated_match_spec, nested_guards} = Enum.reduce(nested_conditions, {match_spec, []}, &handle_condition/2)
    {updated_match_spec, [build_guard(:or, nested_guards) | guards]}
  end

  defp build_guard(:and, [guard]), do: guard
  defp build_guard(:or, [guard]), do: guard
  defp build_guard(:and, guards), do: Enum.reduce(guards, &{:andalso, &2, &1})
  defp build_guard(:or, guards), do: Enum.reduce(guards, &{:orelse, &2, &1})

  defp build_project(_match_spec, nil), do: [:"$_"]

  defp build_project(match_spec, project) do
    [List.to_tuple(Enum.map(project, fn field -> Map.get(match_spec, field) end))]
  end

  defp translate_op(:=), do: :==
  defp translate_op(:>), do: :>
  defp translate_op(:<), do: :<
  defp translate_op(:>=), do: :>=
  defp translate_op(:<=), do: :<=
  defp translate_op(op), do: raise("INVALID OP #{op}")
end
