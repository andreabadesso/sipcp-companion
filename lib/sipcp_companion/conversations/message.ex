defmodule SipcpCompanion.Conversations.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :role, :string
    field :content, :string
    belongs_to :session, SipcpCompanion.Conversations.Session

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:session_id, :role, :content])
    |> validate_required([:role, :content])
    |> validate_inclusion(:role, ["user", "assistant"])
  end
end
