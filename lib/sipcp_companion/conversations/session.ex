defmodule SipcpCompanion.Conversations.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :title, :string, default: "Nova conversa"
    has_many :messages, SipcpCompanion.Conversations.Message

    timestamps()
  end

  def changeset(session, attrs) do
    session
    |> cast(attrs, [:title])
  end
end
