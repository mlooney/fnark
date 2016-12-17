defmodule Fnark.SessionView do
  use Fnark.Web, :view

  def render("login.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end

end
