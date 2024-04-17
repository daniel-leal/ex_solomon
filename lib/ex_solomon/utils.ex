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

  def parse_date(nil), do: nil

  def parse_date(date_string) do
    {:ok, parsed_date} = Timex.parse(date_string, "{D}/{0M}/{YYYY}")
    parsed_date
  end

  def last_months_names(months_quantity) do
    month_names = Timex.Translator.get_months_abbreviated("pt")

    Enum.map(
      months_quantity..1,
      fn x ->
        month_names[
          Timex.now()
          |> Timex.shift(months: -x)
          |> Map.get(:month)
        ]
      end
    )
  end
end
