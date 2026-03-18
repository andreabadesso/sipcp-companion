defmodule SipcpCompanion.AI.Embeddings do
  @moduledoc """
  Local embeddings using Bumblebee + sentence-transformers/all-MiniLM-L6-v2.
  384 dimensions, runs on CPU via EXLA. No API key needed.
  """

  @serving_name SipcpCompanion.EmbeddingServing

  def embed(text) do
    case Nx.Serving.batched_run(@serving_name, text) do
      %{embedding: tensor} ->
        vec = tensor |> Nx.to_flat_list() |> normalize()
        {:ok, vec}

      other ->
        {:error, "unexpected embedding result: #{inspect(other)}"}
    end
  end

  def embed_batch(texts) do
    results =
      Enum.map(texts, fn text ->
        case Nx.Serving.batched_run(@serving_name, text) do
          %{embedding: tensor} ->
            tensor |> Nx.to_flat_list() |> normalize()

          _ ->
            nil
        end
      end)

    if Enum.any?(results, &is_nil/1) do
      {:error, "failed to embed some texts"}
    else
      {:ok, results}
    end
  end

  def dimensions, do: 384

  def serving do
    {:ok, model_info} =
      Bumblebee.load_model({:hf, "sentence-transformers/all-MiniLM-L6-v2"})

    {:ok, tokenizer} =
      Bumblebee.load_tokenizer({:hf, "sentence-transformers/all-MiniLM-L6-v2"})

    Bumblebee.Text.TextEmbedding.text_embedding(model_info, tokenizer,
      compile: [batch_size: 16, sequence_length: 256],
      defn_options: [compiler: EXLA],
      output_attribute: :hidden_state,
      output_pool: :mean_pooling
    )
  end

  defp normalize(vec) do
    norm = :math.sqrt(Enum.reduce(vec, 0.0, fn x, acc -> acc + x * x end))

    if norm > 0.0 do
      Enum.map(vec, &(&1 / norm))
    else
      vec
    end
  end
end
