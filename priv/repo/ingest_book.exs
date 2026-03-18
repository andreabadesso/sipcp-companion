# Ingest all OCR'd book pages into the book_pages table with embeddings.
# Run with: mix run priv/repo/ingest_book.exs

alias SipcpCompanion.Repo
alias SipcpCompanion.Book.Page
alias SipcpCompanion.AI.Embeddings

pages_dir = Path.join([File.cwd!(), "book", "ocr", "pages"])

files =
  pages_dir
  |> File.ls!()
  |> Enum.filter(&String.ends_with?(&1, ".md"))
  |> Enum.sort()

IO.puts("Ingesting #{length(files)} pages with embeddings...")

for file <- files do
  page_num =
    file
    |> String.trim_leading("page_")
    |> String.trim_trailing(".md")
    |> String.to_integer()

  content =
    pages_dir
    |> Path.join(file)
    |> File.read!()
    |> String.trim()

  if String.length(content) > 10 do
    section =
      case Regex.run(~r/^#+\s+(.+)$/m, content) do
        [_, s] -> s
        _ -> "Página #{page_num}"
      end

    # Generate embedding
    embedding =
      case Embeddings.embed(String.slice(content, 0, 1500)) do
        {:ok, vec} -> vec
        {:error, _} -> nil
      end

    # Upsert
    case Repo.get_by(Page, page_number: page_num, section: section) do
      nil ->
        %Page{}
        |> Page.changeset(%{
          page_number: page_num,
          section: section,
          content: content,
          embedding: embedding
        })
        |> Repo.insert!()

      existing ->
        existing
        |> Page.changeset(%{content: content, embedding: embedding})
        |> Repo.update!()
    end

    IO.write(".")
  end
end

IO.puts("\nDone!")
count = Repo.aggregate(Page, :count)
IO.puts("Total pages in database: #{count}")
import Ecto.Query
embedded = Repo.aggregate(from(p in Page, where: not is_nil(p.embedding)), :count)
IO.puts("Pages with embeddings: #{embedded}")
