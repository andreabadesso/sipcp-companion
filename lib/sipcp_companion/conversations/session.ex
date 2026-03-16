defmodule SipcpCompanion.Conversations.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :title, :string, default: "Nova conversa"
    field :summary, :string
    has_many :messages, SipcpCompanion.Conversations.Message

    timestamps()
  end

  def changeset(session, attrs) do
    session
    |> cast(attrs, [:title, :summary])
  end
end
