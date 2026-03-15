defmodule SipcpCompanion.Conversations do
  @moduledoc """
  Persists conversation sessions so the agent remembers
  what was discussed across sessions.
  """

  import Ecto.Query
  alias SipcpCompanion.Repo
  alias SipcpCompanion.Conversations.{Session, Message}

  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  def list_sessions do
    Session
    |> order_by(desc: :updated_at)
    |> limit(20)
    |> Repo.all()
  end

  def add_message(session_id, role, content) do
    %Message{}
    |> Message.changeset(%{session_id: session_id, role: role, content: content})
    |> Repo.insert()
  end

  def get_messages(session_id) do
    Message
    |> where(session_id: ^session_id)
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end
end
