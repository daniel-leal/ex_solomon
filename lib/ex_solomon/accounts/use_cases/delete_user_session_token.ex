defmodule ExSolomon.Accounts.UseCases.DeleteUserSessionToken do
  alias ExSolomon.Accounts.Schemas.UserToken
  alias ExSolomon.Repo

  @doc """
  Deletes the signed token with the given context.
  """
  def execute(token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"))
    :ok
  end
end
