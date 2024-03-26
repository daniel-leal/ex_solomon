defmodule ExSolomon.Utils do
  def convert_to_string_keys(nil), do: %{}

  def convert_to_string_keys(atom_key_map) do
    for {key, val} <- atom_key_map, into: %{}, do: {Atom.to_string(key), val}
  end
end

defmodule ExSolomon.DateUtils do
  def utc_now do
    Process.get(:mock_utc_now) || Timex.now()
  end

  def freeze do
    Process.put(:mock_utc_now, utc_now())
  end

  def freeze(%DateTime{} = on) do
    Process.put(:mock_utc_now, on)
  end

  def unfreeze do
    Process.delete(:mock_utc_now)
  end
end
