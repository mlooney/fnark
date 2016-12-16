defmodule Fnark.LinkView do
  use Fnark.Web, :view

  def render("index.json", %{links: links}) do
    %{links: Enum.map(links, &link_json/1)}
  end

  def link_json(link) do
    %{
      id: link.id,
      blurb: link.blurb,
      url: link.url,
      inserted_at: link.inserted_at,
      updated_at: link.inserted_at,
      user_id: link.user_id
    }
  end
end
