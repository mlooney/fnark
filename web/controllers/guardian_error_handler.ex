defmodule Fnark.GuardianErrorHandler do
  use Fnark.Web, :controller
  alias Fnark.GuardianErrorView
  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(GuardianErrorView, :forbidden)
  end
end
