defmodule ExSolomonWeb.UserLive.Login do
  use ExSolomonWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="p-8">
      <.link
        class="invisible md:visible lg:visible absolute right-8 top-8 select-none rounded-md p-3 text-gray-900 hover:bg-gray-100 dark:text-foreground dark:hover:bg-zinc-600"
        patch={~p"/users/register"}
      >
        Registre-se
      </.link>

      <div class="flex flex-col justify-center">
        <div class="flex flex-col gap-2 text-center">
          <h1 class="text-2xl font-semibold tracking-tighter">
            Acessar Painel
          </h1>
          <p class="text-sm text-gray-600">
            Acompanhe suas finanças pelo painel
          </p>
        </div>

        <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Senha" required />

          <:actions>
            <div class="flex flex-col md:flex-row gap-4 items-center justify-between">
              <.input field={@form[:remember_me]} type="checkbox" label="Mantenha-me logado" />
              <.link
                href={~p"/users/reset_password"}
                class="text-sm text-gray-900 font-semibold dark:text-foreground dark:hover:text-zinc-400"
              >
                Esqueceu sua senha?
              </.link>
            </div>
          </:actions>

          <:actions>
            <div class="flex flex-1 flex-col gap-4">
              <.button
                phx-disable-with="Signing in..."
                class="w-full bg-emerald-700 hover:bg-emerald-800"
              >
                Acessar Painel
              </.button>

              <.link
                class="md:invisible lg:invisible text-foreground bg-gray-300 dark:bg-zinc-600 dark:hover:bg-zinc-700 p-2 text-center rounded-lg"
                patch={~p"/users/register"}
              >
                Registre-se
              </.link>
            </div>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
