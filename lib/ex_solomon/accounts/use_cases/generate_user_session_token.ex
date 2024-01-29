defmodule ExSolomon.Accounts.UseCases.GenerateUserSessionToken do
  alias ExSolomon.Accounts.Schemas.{UserToken}
  alias ExSolomon.Repo

  @doc """
  Generates a session token.
  """
  def execute(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end
end
