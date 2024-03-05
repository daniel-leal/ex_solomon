defmodule ExSolomonWeb.Helpers do
  @moduledoc """
  Helper functions for HTML-related tasks.
  """

  use Timex

  @doc """
  Normalizes a money value represented as a map to a decimal format.

  ## Examples

      iex> ExSolomonWeb.Helpers.normalize_money(%Money{amount: 100, currency: "USD"})
      #Decimal<100>

      iex> ExSolomonWeb.Helpers.normalize_money(100)
      #Decimal<100>

      iex> ExSolomonWeb.Helpers.normalize_money(nil)
      #Decimal<0.00>

  """
  def normalize_money(value) when is_map(value) do
    Money.to_decimal(value)
  end

  def normalize_money(value) when is_bitstring(value) do
    case Float.parse(value) do
      {float_value, _} ->
        float_value
        |> to_string()
        |> Decimal.new()

      :error ->
        Decimal.new("0.00")
    end

    {:ok, decimal} = Decimal.cast(value)
    decimal
  end

  def normalize_money(value) when is_number(value) do
    {:ok, decimal} = Decimal.cast(value)
    decimal
  end

  def normalize_money(value) when is_nil(value) do
    Decimal.new("0.00")
  end

  @doc """
  Formats the given date to a local date string.

  ## Examples

   	iex> local_date(nil)
   	nil

    iex> local_date({2024, 2, 20})
  	"20/02/2024"

  """
  def local_date(date) when is_nil(date) do
    "-"
  end

  def local_date(date) do
    Timex.format!(date, "%d/%m/%Y", :strftime)
  end
end
