defmodule SipcpCompanion.Repo.Migrations.AddSummaryToSessions do
  use Ecto.Migration

  def change do
    alter table(:sessions) do
      add :summary, :text
    end
  end
end
