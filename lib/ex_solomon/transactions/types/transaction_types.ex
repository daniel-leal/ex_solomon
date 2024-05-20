defmodule ExSolomon.Transactions.Types.TransactionTypes do
  @kinds [
    %{description: "Pix", value: "pix"},
    %{description: "Cartão de Crédito", value: "credit"},
    %{description: "Débito", value: "debit"},
    %{description: "Dinheiro", value: "cash"},
    %{description: "Transferência", value: "transfer"}
  ]

  def kinds do
    @kinds
  end

  def get_description(kind) do
    Enum.find_value(@kinds, &if(&1.value == kind, do: &1.description))
  end
end
