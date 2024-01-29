defmodule ExSolomon.Accounts.UseCases.RegisterUser do
  alias ExSolomon.Accounts.Schemas.User
  alias ExSolomon.Repo

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def execute(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end
end
