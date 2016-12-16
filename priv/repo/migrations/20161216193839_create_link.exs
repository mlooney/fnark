defmodule Fnark.Repo.Migrations.CreateLink do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string, null: false
      add :blurb, :string, null: false
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end
    create index(:links, [:user_id])

  end
end
