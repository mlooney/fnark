defmodule Fnark.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :crypted_password, :string
      add :realname, :string, default: "Some Guy"
      add :username, :string, null: false
      add :admin, :boolean, null: false, default: false

      timestamps()
    end
    create unique_index(:users, [:email])
    create unique_index(:users, [:username])

  end
end
