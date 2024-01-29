defmodule ExSolomon.Accounts.UseCases.ChangeUserEmail do
  alias ExSolomon.Accounts.Schemas.User

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def execute(user, attrs \\ %{}) do
    User.email_changeset(user, attrs, validate_email: false)
  end
end
