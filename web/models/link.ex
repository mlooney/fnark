defmodule Fnark.Link do
  use Fnark.Web, :model

  schema "links" do
    field :url, :string
    field :blurb, :string
    belongs_to :user, Fnark.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url])
    |> validate_required([:url])
  end
end
