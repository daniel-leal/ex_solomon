defmodule ExSolomon.Filter do
  import Ecto.Query

  def fetch(queryable, filters) when filters == %{}, do: queryable

  def fetch(queryable, filters) do
    filters
    |> remove_empty()
    |> Enum.reduce(queryable, &do_filter/2)
  end

  def filter_to_form(filter) do
    Enum.reduce(filter, %{}, fn
      {{_s, _k, f}, v}, acc -> Map.merge(acc, %{f => v})
      {{_s, k}, v}, acc -> Map.merge(acc, %{k => v})
      {k, v}, acc -> Map.merge(acc, %{k => v})
    end)
  end

  defp remove_empty(filters) do
    Enum.reduce(filters, %{}, fn
      {_k, nil}, acc -> Map.merge(acc, %{})
      {_k, ""}, acc -> Map.merge(acc, %{})
      {k, v}, acc -> Map.merge(acc, %{k => v})
    end)
  end

  defp do_filter({{schema, key, _field}, val}, query), do: do_filter(query, schema, key, val)

  defp do_filter({{schema, key}, val}, query), do: do_filter(query, schema, key, val)

  defp do_filter({key, val}, query), do: do_filter(query, nil, key, val)

  defp do_filter(query, schema, key, val) do
    Regex.scan(~r/(.*)_(.*)$/, Atom.to_string(key))
    |> filter_by_query(query, schema, key, val)
  end

  defp filter_by_query([[_, _column, "eq"]], query, schema, key, val),
    do: where(query, ^eq(schema, key, val))

  defp filter_by_query([[_, column, "ilike"]], query, schema, _key, val),
    do: where(query, ^ilike(schema, String.to_atom(column), "%#{val}%"))

  defp filter_by_query([[_, column, "gte"]], query, schema, _key, val),
    do: where(query, ^gte(schema, String.to_atom(column), val))

  defp filter_by_query([[_, column, "gt"]], query, schema, _key, val),
    do: where(query, ^gt(schema, String.to_atom(column), val))

  defp filter_by_query([[_, column, "lte"]], query, schema, _key, val),
    do: where(query, ^lte(schema, String.to_atom(column), val))

  defp filter_by_query([[_, column, "lt"]], query, schema, _key, val),
    do: where(query, ^lt(schema, String.to_atom(column), val))

  defp filter_by_query([[_, column, "array"]], query, schema, _key, val),
    do: where(query, ^in_array(schema, String.to_atom(column), val))

  defp filter_by_query([[_, column, "in"]], query, schema, _key, val),
    do: where(query, ^in_query(schema, String.to_atom(column), val))

  defp filter_by_query(_, query, schema, key, val), do: where(query, ^eq(schema, key, val))

  defp eq(nil, key, val), do: dynamic([m], field(m, ^key) == ^val)
  defp eq(schema, key, val), do: dynamic([{^schema, m}], field(m, ^key) == ^val)

  defp gt(nil, key, val), do: dynamic([m], field(m, ^key) > ^val)
  defp gt(schema, key, val), do: dynamic([{^schema, m}], field(m, ^key) > ^val)

  defp lt(nil, key, val), do: dynamic([m], field(m, ^key) < ^val)
  defp lt(schema, key, val), do: dynamic([{^schema, m}], field(m, ^key) < ^val)

  defp gte(nil, key, val), do: dynamic([m], field(m, ^key) >= ^val)
  defp gte(schema, key, val), do: dynamic([{^schema, m}], field(m, ^key) >= ^val)

  defp lte(nil, key, val), do: dynamic([m], field(m, ^key) <= ^val)
  defp lte(schema, key, val), do: dynamic([{^schema, m}], field(m, ^key) <= ^val)

  defp in_query(nil, key, val), do: dynamic([m], field(m, ^key) in ^val)
  defp in_query(schema, key, val), do: dynamic([{^schema, m}], field(m, ^key) in ^val)

  defp in_array(nil, key, val), do: dynamic([m], ^val == fragment("ANY(?)", field(m, ^key)))

  defp in_array(schema, key, val),
    do: dynamic([{^schema, m}], ^val == fragment("ANY(?)", field(m, ^key)))

  defp ilike(nil, key, val),
    do: dynamic([m], ilike(fragment("?::text", field(m, ^key)), ^val))

  defp ilike(schema, key, val),
    do: dynamic([{^schema, m}], ilike(fragment("?::text", field(m, ^key)), ^val))
end
