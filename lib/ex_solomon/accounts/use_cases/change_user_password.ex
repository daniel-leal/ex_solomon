defmodule ExSolomon.Accounts.UseCases.ChangeUserPassword do
  alias ExSolomon.Accounts.Schemas.User

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def execute(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end
end
