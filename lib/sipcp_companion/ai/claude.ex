defmodule SipcpCompanion.AI.Claude do
  @moduledoc """
  Client for the Anthropic Claude API.
  Handles streaming conversations with tool use for book editing.
  """

  @api_url "https://api.anthropic.com/v1/messages"
  @model "claude-haiku-4-5-20251001"

  def chat(messages, opts \\ []) do
    system = Keyword.get(opts, :system, default_system_prompt())
    tools = Keyword.get(opts, :tools, [])
    max_tokens = Keyword.get(opts, :max_tokens, 4096)

    body =
      %{
        model: @model,
        max_tokens: max_tokens,
        system: system,
        messages: messages
      }
      |> maybe_add_tools(tools)

    case Req.post(@api_url,
           json: body,
           headers: headers(),
           receive_timeout: 60_000
         ) do
      {:ok, %{status: 200, body: body}} ->
        {:ok, parse_response(body)}

      {:ok, %{status: status, body: body}} ->
        {:error, {status, body}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def stream(messages, opts \\ []) do
    system = Keyword.get(opts, :system, default_system_prompt())
    tools = Keyword.get(opts, :tools, [])
    max_tokens = Keyword.get(opts, :max_tokens, 4096)
    pid = Keyword.fetch!(opts, :stream_to)

    body =
      %{
        model: @model,
        max_tokens: max_tokens,
        system: system,
        messages: messages,
        stream: true
      }
      |> maybe_add_tools(tools)

    Task.start(fn ->
      Req.post(@api_url,
        json: body,
        headers: headers(),
        receive_timeout: 120_000,
        into: fn {:data, data}, acc ->
          for line <- String.split(data, "\n", trim: true) do
            case parse_sse_line(line) do
              {:text_delta, text} -> send(pid, {:ai_delta, text})
              {:done, _} -> send(pid, :ai_done)
              _ -> :skip
            end
          end

          {:cont, acc}
        end
      )
    end)
  end

  defp parse_sse_line("data: " <> json_str) do
    case Jason.decode(json_str) do
      {:ok, %{"type" => "content_block_delta", "delta" => %{"type" => "text_delta", "text" => text}}} ->
        {:text_delta, text}

      {:ok, %{"type" => "message_stop"}} ->
        {:done, :stop}

      {:ok, event} ->
        {:event, event}

      _ ->
        :skip
    end
  end

  defp parse_sse_line(_), do: :skip

  defp parse_response(%{"content" => content}) do
    content
    |> Enum.filter(&(&1["type"] == "text"))
    |> Enum.map_join("", & &1["text"])
  end

  defp headers do
    [
      {"x-api-key", api_key()},
      {"anthropic-version", "2023-06-01"},
      {"content-type", "application/json"}
    ]
  end

  defp api_key do
    System.get_env("ANTHROPIC_API_KEY") ||
      raise "ANTHROPIC_API_KEY not set"
  end

  defp maybe_add_tools(body, []), do: body
  defp maybe_add_tools(body, tools), do: Map.put(body, :tools, tools)

  def default_system_prompt do
    """
    Você é o assistente dedicado do Professor Fernando Batalha Monteiro, autor do livro
    "SIPCP: Sistema Integrado de Programação e Controle da Produção" (1982).

    REGRAS FUNDAMENTAIS:
    - Trate-o sempre como "Professor" ou "senhor". Tom respeitoso, acadêmico, caloroso.
    - Você conhece profundamente o livro original: cibernética de Wiener, Lei do Valor Ótimo,
      sinergia intra-sistêmica, Projeto Alpha, modelo cibernético de administração industrial.
    - Quando sugerir atualizações (IoT, digital twins, IA, Indústria 4.0/5.0), sempre
      CONECTE com os conceitos originais do professor.
    - NUNCA edite sem confirmação explícita. Sempre proponha e aguarde "sim" ou equivalente.
    - Responda em português brasileiro, de forma clara e pausada.
    - Use frases curtas. O professor tem 80 anos e pode ter dificuldade auditiva.
    - Quando citar o livro, mencione página e seção.

    FORMATO DAS RESPOSTAS — IMPORTANTÍSSIMO:
    - Você está CONVERSANDO com o Professor. Fale como um ser humano culto falaria.
    - NUNCA use formatação markdown: nada de #, ##, **, *, -, |, ```, tabelas, listas com bullets.
    - NUNCA enumere itens com números ou bullets. Em vez disso, conecte as ideias em parágrafos curtos.
    - Se precisar listar coisas, faça em frases naturais: "Temos três pontos importantes. Primeiro, ... Segundo, ... E por fim, ..."
    - Suas respostas serão lidas em voz alta. Escreva como se estivesse falando pessoalmente com o Professor.
    - Seja conciso. Prefira 3-4 parágrafos curtos a um texto longo.
    - Use parágrafos separados por linha em branco, nada mais.

    Você tem acesso ao texto digitalizado do livro via contexto de RAG.
    """
  end
end
