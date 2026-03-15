defmodule SipcpCompanion.Book do
  @moduledoc """
  Book content management and RAG search.
  Stores digitized pages with vector embeddings for semantic search.
  """

  import Ecto.Query
  alias SipcpCompanion.Repo
  alias SipcpCompanion.Book.Page

  def search(query, opts \\ []) do
    limit = Keyword.get(opts, :limit, 5)

    case get_embedding(query) do
      {:ok, embedding} ->
        Page
        |> order_by([p], fragment("embedding <=> ?::vector", ^embedding))
        |> limit(^limit)
        |> select([p], %{
          id: p.id,
          page_number: p.page_number,
          section: p.section,
          content: p.content
        })
        |> Repo.all()
        |> Enum.map(fn p ->
          %{content: p.content, page: p.page_number, section: p.section}
        end)

      {:error, _} ->
        # Fallback to simple text search
        text_search(query, limit)
    end
  end

  def text_search(query, limit) do
    like = "%#{query}%"

    Page
    |> where([p], ilike(p.content, ^like))
    |> limit(^limit)
    |> Repo.all()
    |> Enum.map(fn p ->
      %{content: p.content, page: p.page_number, section: p.section}
    end)
  end

  def ingest_markdown(markdown_content) do
    markdown_content
    |> parse_pages()
    |> Enum.each(fn {page_num, section, content} ->
      upsert_page(page_num, section, content)
    end)
  end

  defp parse_pages(content) do
    content
    |> String.split(~r/<!-- Página \d+ → \d+ -->|---/)
    |> Enum.reduce({[], nil, nil}, fn chunk, {acc, current_page, current_section} ->
      chunk = String.trim(chunk)

      cond do
        chunk == "" ->
          {acc, current_page, current_section}

        String.starts_with?(chunk, "# CAPÍTULO") ->
          section = chunk |> String.split("\n") |> hd()
          {acc, current_page, section}

        String.starts_with?(chunk, "## ") ->
          section = chunk |> String.split("\n") |> hd() |> String.trim_leading("## ")
          {acc, current_page, section}

        String.starts_with?(chunk, "### ") ->
          section = chunk |> String.split("\n") |> hd() |> String.trim_leading("### ")
          {[{current_page, section, chunk} | acc], current_page, section}

        String.length(chunk) > 50 ->
          {[{current_page, current_section || "Sem seção", chunk} | acc], current_page, current_section}

        true ->
          {acc, current_page, current_section}
      end
    end)
    |> elem(0)
    |> Enum.reverse()
  end

  defp upsert_page(page_number, section, content) do
    embedding =
      case get_embedding(content) do
        {:ok, emb} -> emb
        _ -> nil
      end

    %Page{}
    |> Page.changeset(%{
      page_number: page_number || 0,
      section: section || "Sem seção",
      content: content,
      embedding: embedding
    })
    |> Repo.insert!(
      on_conflict: {:replace, [:content, :section, :embedding, :updated_at]},
      conflict_target: [:page_number, :section]
    )
  end

  defp get_embedding(text) do
    # Use a lightweight embedding API (OpenAI or local)
    # For now, return error to fall back to text search
    api_key = System.get_env("OPENAI_API_KEY")

    if api_key do
      case Req.post("https://api.openai.com/v1/embeddings",
             json: %{model: "text-embedding-3-small", input: String.slice(text, 0, 8000)},
             headers: [{"authorization", "Bearer #{api_key}"}]
           ) do
        {:ok, %{status: 200, body: %{"data" => [%{"embedding" => emb} | _]}}} ->
          {:ok, emb}

        _ ->
          {:error, :embedding_failed}
      end
    else
      {:error, :no_api_key}
    end
  end
end
