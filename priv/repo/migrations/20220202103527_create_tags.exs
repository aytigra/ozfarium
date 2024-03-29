defmodule Ozfarium.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:tags, [:user_id])
  end
end
