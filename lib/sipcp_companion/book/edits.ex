defmodule SipcpCompanion.Book.Edits do
  import Ecto.Query
  alias SipcpCompanion.Repo
  alias SipcpCompanion.Book.Edit

  def create_pending_edit(session_id, attrs) do
    %Edit{}
    |> Edit.changeset(Map.merge(attrs, %{session_id: session_id, status: "pending"}))
    |> Repo.insert()
  end

  def approve_edit(edit_id) do
    Repo.get!(Edit, edit_id)
    |> Edit.changeset(%{status: "approved"})
    |> Repo.update()
  end

  def reject_edit(edit_id) do
    Repo.get!(Edit, edit_id)
    |> Edit.changeset(%{status: "rejected"})
    |> Repo.update()
  end

  def list_pending_edits(session_id) do
    Edit
    |> where(session_id: ^session_id, status: "pending")
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end

  def list_session_edits(session_id) do
    Edit
    |> where(session_id: ^session_id)
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end
end
