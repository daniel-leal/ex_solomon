defmodule ExSolomon.Utils do
  def convert_to_string_keys(nil), do: %{}

  def convert_to_string_keys(atom_key_map) do
    for {key, val} <- atom_key_map, into: %{}, do: {Atom.to_string(key), val}
  end
end
