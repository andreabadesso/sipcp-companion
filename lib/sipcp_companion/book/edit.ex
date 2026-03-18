defmodule SipcpCompanion.Book.Edit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "book_edits" do
    field :page_number, :integer
    field :section, :string
    field :original_text, :string
    field :proposed_text, :string
    field :rationale, :string
    field :status, :string, default: "pending"
    belongs_to :session, SipcpCompanion.Conversations.Session

    timestamps()
  end

  def changeset(edit, attrs) do
    edit
    |> cast(attrs, [:session_id, :page_number, :section, :original_text, :proposed_text, :rationale, :status])
    |> validate_required([:page_number, :proposed_text, :status])
    |> validate_inclusion(:status, ["pending", "approved", "rejected"])
  end
end
