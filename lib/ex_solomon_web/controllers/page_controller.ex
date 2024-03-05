defmodule ExSolomonWeb.PageController do
  use ExSolomonWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
