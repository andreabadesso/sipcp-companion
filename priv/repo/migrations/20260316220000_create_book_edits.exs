defmodule SipcpCompanion.Repo.Migrations.CreateBookEdits do
  use Ecto.Migration

  def change do
    create table(:book_edits) do
      add :session_id, references(:sessions, on_delete: :nilify_all)
      add :page_number, :integer, null: false
      add :section, :string
      add :original_text, :text
      add :proposed_text, :text, null: false
      add :rationale, :string
      add :status, :string, null: false, default: "pending"

      timestamps()
    end

    create index(:book_edits, [:session_id])
    create index(:book_edits, [:status])
  end
end
