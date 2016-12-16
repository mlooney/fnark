defmodule Fnark.LinkController do
  use Fnark.Web, :controller
  alias Fnark.Link

  def index(conn, _params) do
    render conn, "index.json", links: Repo.all(Link)
  end
end
