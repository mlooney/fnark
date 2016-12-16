defmodule Fnark.User do
  use Fnark.Web, :model

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :realname, :string
    field :username, :string
    has_many :links, Fnark.Link

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :crypted_password, :realname, :username])
    |> validate_required([:email, :crypted_password, :realname, :username])
    |> unique_constraint(:email)
  end
end
