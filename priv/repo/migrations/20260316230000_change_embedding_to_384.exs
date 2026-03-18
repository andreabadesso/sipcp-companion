defmodule SipcpCompanion.Repo.Migrations.ChangeEmbeddingTo384 do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE book_pages DROP COLUMN IF EXISTS embedding"
    execute "ALTER TABLE book_pages ADD COLUMN embedding vector(384)"
    execute "DROP INDEX IF EXISTS book_pages_embedding_index"
    execute "CREATE INDEX book_pages_embedding_index ON book_pages USING ivfflat (embedding vector_cosine_ops) WITH (lists = 20)"
  end

  def down do
    execute "ALTER TABLE book_pages DROP COLUMN IF EXISTS embedding"
    execute "ALTER TABLE book_pages ADD COLUMN embedding vector(1536)"
  end
end
