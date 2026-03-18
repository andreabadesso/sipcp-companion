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

    # Hybrid: text match first (exact), then semantic to fill remaining slots
    text_results = text_search(query, limit)
    text_ids = Enum.map(text_results, & &1.page)

    semantic_results =
      case SipcpCompanion.AI.Embeddings.embed(query) do
        {:ok, embedding} ->
          vector = Pgvector.new(embedding)

          Page
          |> where([p], not is_nil(p.embedding))
          |> where([p], p.page_number not in ^text_ids)
          |> order_by([p], fragment("embedding <=> ?", ^vector))
          |> limit(^limit)
          |> select([p], %{page_number: p.page_number, section: p.section, content: p.content})
          |> Repo.all()
          |> Enum.map(fn p -> %{content: p.content, page: p.page_number, section: p.section} end)

        {:error, _} ->
          []
      end

    (text_results ++ semantic_results) |> Enum.take(limit)
  rescue
    e ->
      IO.inspect(e, label: "[Book.search error]")
      []
  end

  def text_search(query, limit) do
    stop_words = ~w(que como posso sobre escrevi mostre meu minha para com por uma dos das nos nas seu sua este esta isso aqui ele ela livro)

    keywords =
      query
      |> String.downcase()
      |> String.replace(~r/[^\w\sáàâãéèêíìîóòôõúùûç]/u, "")
      |> String.split()
      |> Enum.reject(fn w -> String.length(w) < 3 || w in stop_words end)
      |> Enum.take(4)

    case keywords do
      [] -> []
      words ->
        # Try progressively: all words AND, then fewer, then single best
        try_search(words, limit) ||
          try_search(Enum.take(words, 2), limit) ||
          try_search([List.last(words)], limit) ||
          []
    end
  rescue
    _ -> []
  end

  defp try_search(words, limit) do
    # Build AND query — all keywords must appear
    base =
      Page
      |> select([p], %{page_number: p.page_number, section: p.section, content: p.content})
      |> limit(^limit)

    query =
      Enum.reduce(words, base, fn word, q ->
        like = "%#{word}%"
        where(q, [p], ilike(p.content, ^like))
      end)

    case Repo.all(query) do
      [] -> nil
      results -> Enum.map(results, fn p -> %{content: p.content, page: p.page_number, section: p.section} end)
    end
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
