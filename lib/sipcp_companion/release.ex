defmodule SipcpCompanion.Release do
  @moduledoc """
  Release tasks for running migrations in production.
  Usage: bin/sipcp_companion eval "SipcpCompanion.Release.migrate()"
  """

  @app :sipcp_companion

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def seed do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, fn repo ->
        seed_file = Application.app_dir(:sipcp_companion, "priv/repo/seed.sql")

        if File.exists?(seed_file) do
          sql = File.read!(seed_file)
          Ecto.Adapters.SQL.query!(repo, sql)
          IO.puts("Seed loaded successfully")
        else
          IO.puts("No seed file found at #{seed_file}")
        end
      end)
    end
  end

  def migrate_and_seed do
    migrate()
    seed()
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
