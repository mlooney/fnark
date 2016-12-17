defmodule Fnark.User do
  use Fnark.Web, :model

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    field :realname, :string
    field :username, :string
    has_many :links, Fnark.Link

    timestamps()
  end

  @required_fields ~w(email password realname username)a
  @optional_fields ~w()a

  def find_by_email(email) do
    from a in __MODULE__,
    where: a.email == ^email
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields, @optional_fields)
    |> put_pass_hash
    |> unique_constraint(:email)
  end

  defp put_pass_hash(changeset) do
    password = changeset.changes.password
    put_change(changeset, :crypted_password, Comeonin.Bcrypt.hashpwsalt(password))
  end
end
