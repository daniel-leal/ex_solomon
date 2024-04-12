defmodule ExSolomon.Transactions.UseCases.CalculateVariation do
  @moduledoc """
  Calculate the variation of a previous value
  """

  @doc """
  Calculates the percentage variation in revenue compared to the previous month for the specified
  user.

  variation = ((current_value - past_value) / past_value) * 100

  ## Parameters
    - `current_revenue`: The current month's revenue for the user.
    - `past_revenue`: The past month's revenue for the user.

  ## Returns
  The percentage variation in revenue compared to the previous month as a decimal.

  ## Examples
      iex> execute(Decimal.new("1500.00"), Decimal.new("1600.00"))
      25.0
  """
  def execute(current_value, past_value) when current_value != past_value do
    if Decimal.equal?(past_value, Decimal.new("0.00")) do
      Decimal.new("0.0")
    else
      calculate_variation(current_value, past_value)
    end
  end

  def execute(_current_value, _past_value), do: Decimal.new("0.0")

  defp calculate_variation(current_value, past_value) do
    current_value
    |> Decimal.sub(past_value)
    |> Decimal.div(Decimal.abs(past_value))
    |> Decimal.mult(100)
    |> Decimal.round(1)
  end
end
