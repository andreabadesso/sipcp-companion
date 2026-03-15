defmodule SipcpCompanion.Book.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "book_pages" do
    field :page_number, :integer
    field :section, :string
    field :content, :string
    field :embedding, Pgvector.Ecto.Vector

    timestamps()
  end

  def changeset(page, attrs) do
    page
    |> cast(attrs, [:page_number, :section, :content, :embedding])
    |> validate_required([:content])
  end
end
