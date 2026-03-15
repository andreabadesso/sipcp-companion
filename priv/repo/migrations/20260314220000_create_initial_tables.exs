defmodule SipcpCompanion.Repo.Migrations.CreateInitialTables do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS vector"

    create table(:book_pages) do
      add :page_number, :integer
      add :section, :string
      add :content, :text, null: false
      add :embedding, :vector, size: 1536

      timestamps()
    end

    create unique_index(:book_pages, [:page_number, :section])
    create index(:book_pages, ["embedding vector_cosine_ops"], using: "ivfflat")

    create table(:sessions) do
      add :title, :string, default: "Nova conversa"
      timestamps()
    end

    create table(:messages) do
      add :session_id, references(:sessions, on_delete: :delete_all), null: false
      add :role, :string, null: false
      add :content, :text, null: false
      timestamps()
    end

    create index(:messages, [:session_id])
  end

  def down do
    drop table(:messages)
    drop table(:sessions)
    drop table(:book_pages)
  end
end
