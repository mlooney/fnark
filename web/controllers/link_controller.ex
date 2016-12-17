defmodule Fnark.LinkController do
  use Fnark.Web, :controller
  alias Fnark.Link
  plug Guardian.Plug.EnsureAuthenticated, [handler: Fnark.GuardianErrorHandler] when action in [:create, :update, :delete]

  def index(conn, _params) do
    render conn, "index.json", %{links: Repo.all(Link), current_user: Guardian.Plug.current_resource(conn)}
  end

end
