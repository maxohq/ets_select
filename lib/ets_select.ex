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
    {match_spec, guards} =
      Enum.reduce(conditions, {%{}, []}, fn [op, key, value], {match_spec, guards} ->
        var = Map.get(match_spec, key, :"$#{map_size(match_spec) + 2}")
        updated_match_spec = Map.put(match_spec, key, var)
        updated_guards = [{op, var, value} | guards]
        {updated_match_spec, updated_guards}
      end)

    match_head = {:"$1", match_spec}
    guard = [build_guard(type, Enum.reverse(guards))]
    result = build_project(match_spec, project)

    [{match_head, guard, result}]
  end

  defp build_guard(:and, guards), do: Enum.reduce(guards, &{:andalso, &2, &1})
  defp build_guard(:or, guards), do: Enum.reduce(guards, &{:orelse, &2, &1})

  defp build_project(match_spec, nil), do: [:"$_"]
  defp build_project(match_spec, project) do
    [List.to_tuple(Enum.map(project, fn field -> Map.get(match_spec, field) end))]
  end
end
