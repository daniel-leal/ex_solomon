defmodule ExSolomon.Accounts do
  alias ExSolomon.Accounts.UseCases

  defdelegate apply_user_email(user, password, attrs),
    to: UseCases.ApplyUserEmail,
    as: :execute

  defdelegate change_user_email(user, attrs \\ %{}),
    to: UseCases.ChangeUserEmail,
    as: :execute

  defdelegate change_user_password(user, attrs \\ %{}),
    to: UseCases.ChangeUserPassword,
    as: :execute

  defdelegate change_user_registration(user, attrs \\ %{}),
    to: UseCases.ChangeUserRegistration,
    as: :execute

  defdelegate confirm_user(token),
    to: UseCases.ConfirmUser,
    as: :execute

  defdelegate delete_user_session_token(token),
    to: UseCases.DeleteUserSessionToken,
    as: :execute

  defdelegate deliver_user_confirmation_instructions(user, confirmation_url_fun),
    to: UseCases.DeliverUserConfirmationInstructions,
    as: :execute

  defdelegate deliver_user_reset_password_instructions(user, reset_password_url_fun),
    to: UseCases.DeliverUserResetPasswordInstructions,
    as: :execute

  defdelegate deliver_user_update_email_instructions(
                user,
                current_email,
                update_email_url_fun
              ),
              to: UseCases.DeliverUserUpdateEmailInstructions,
              as: :execute

  defdelegate generate_user_session_token(user),
    to: UseCases.GenerateUserSessionToken,
    as: :execute

  defdelegate reset_user_password(user, attrs),
    to: UseCases.ResetUserPassword,
    as: :execute

  defdelegate register_user(attrs),
    to: UseCases.RegisterUser,
    as: :execute

  defdelegate update_user_email(user, token),
    to: UseCases.UpdateUserEmail,
    as: :execute

  defdelegate update_user_password(user, password, attrs),
    to: UseCases.UpdateUserPassword,
    as: :execute
end
