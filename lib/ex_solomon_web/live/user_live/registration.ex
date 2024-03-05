defmodule ExSolomonWeb.UserLive.Registration do
  use ExSolomonWeb, :live_view

  alias ExSolomon.Accounts

  alias ExSolomon.Accounts.UseCases.{
    ChangeUserRegistration
  }

  alias ExSolomon.Accounts.Schemas.User

  def render(assigns) do
    ~H"""
    <div class="p-8">
      <.link
        class="invisible md:visible lg:visible absolute right-8 top-8 select-none rounded-md p-3 text-gray-900 hover:bg-gray-100 dark:text-foreground dark:hover:bg-zinc-600"
        patch={~p"/users/log_in"}
      >
        Fazer Login
      </.link>

      <div class="flex w-[350px] flex-col justify-center">
        <div class="flex flex-col text-center">
          <h1 class="text-2xl font-semibold tracking-tighter">
            Crie sua conta grátis!
          </h1>
        </div>

        <.simple_form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
          action={~p"/users/log_in?_action=registered"}
          method="post"
        >
          <.error :if={@check_errors}>
            Ocorreu um erro ao realizar o cadastro. Tente novamente mais tarde!
          </.error>

          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Senha" required />

          <:actions>
            <div class="flex flex-1 flex-col gap-4">
              <.button
                phx-disable-with="Criando conta..."
                class="w-full bg-emerald-700 hover:bg-emerald-800"
              >
                Criar conta
              </.button>

              <.link
                class="md:invisible lg:invisible text-foreground bg-gray-300 dark:bg-zinc-600 dark:hover:bg-zinc-700 p-2 text-center rounded-lg"
                patch={~p"/users/log_in"}
              >
                Voltar para Login
              </.link>
            </div>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = ChangeUserRegistration.execute(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = ChangeUserRegistration.execute(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
