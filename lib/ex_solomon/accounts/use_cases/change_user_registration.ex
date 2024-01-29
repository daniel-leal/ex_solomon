defmodule ExSolomon.Accounts.UseCases.ChangeUserRegistration do
  alias ExSolomon.Accounts.Schemas.User

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def execute(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false, validate_email: false)
  end
end
