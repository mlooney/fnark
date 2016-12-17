defmodule Fnark.GuardianErrorView do
  use Fnark.Web, :view

  def render("forbidden.json", _assigns) do
    %{message: "Forbade."}
  end
end
