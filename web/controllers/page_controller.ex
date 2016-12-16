defmodule Fnark.PageController do
  use Fnark.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
