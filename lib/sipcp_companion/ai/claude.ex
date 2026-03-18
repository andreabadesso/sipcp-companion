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
      # Use Process dictionary to carry tool state across chunks
      Process.put(:sse_acc, %{tool: nil})

      Req.post(@api_url,
        json: body,
        headers: headers(),
        receive_timeout: 120_000,
        into: fn {:data, data}, {req, resp} ->
          acc = Process.get(:sse_acc)

          new_acc =
            Enum.reduce(String.split(data, "\n", trim: true), acc, fn line, acc ->
              handle_sse_line(line, pid, acc)
            end)

          Process.put(:sse_acc, new_acc)
          {:cont, {req, resp}}
        end
      )
    end)
  end

  defp handle_sse_line("data: " <> json_str, pid, acc) do
    case Jason.decode(json_str) do
      {:ok, %{"type" => "content_block_start", "content_block" => %{"type" => "tool_use", "id" => id, "name" => name}}} ->
        send(pid, {:tool_start, name, id})
        %{acc | tool: %{id: id, name: name, input: ""}}

      {:ok, %{"type" => "content_block_delta", "delta" => %{"type" => "input_json_delta", "partial_json" => json}}} when acc.tool != nil ->
        send(pid, {:tool_delta, json})
        put_in(acc, [:tool, :input], acc.tool.input <> json)

      {:ok, %{"type" => "content_block_stop"}} when acc.tool != nil ->
        send(pid, :tool_done)
        %{acc | tool: nil}

      {:ok, %{"type" => "content_block_stop"}} ->
        acc

      {:ok, %{"type" => "content_block_delta", "delta" => %{"type" => "text_delta", "text" => text}}} ->
        send(pid, {:ai_delta, text})
        acc

      {:ok, %{"type" => "message_stop"}} ->
        send(pid, :ai_done)
        acc

      _ ->
        acc
    end
  end

  defp handle_sse_line(_, _pid, acc), do: acc

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

  def book_editing_tools do
    [
      %{
        name: "propose_edit",
        description: """
        Use esta ferramenta quando o Professor pedir para mudar, adicionar ou atualizar
        qualquer texto do livro. SEMPRE use esta ferramenta em vez de escrever o texto
        proposto diretamente na conversa. O texto será mostrado visualmente e lido em voz alta.
        """,
        input_schema: %{
          type: "object",
          properties: %{
            page_number: %{type: "integer", description: "Número da página sendo editada"},
            section: %{type: "string", description: "Título da seção dentro da página"},
            proposed_text: %{type: "string", description: "O texto proposto completo. Prosa simples, sem markdown."},
            rationale: %{type: "string", description: "Uma frase explicando por que esta mudança é apropriada. Será lida em voz alta."}
          },
          required: ["page_number", "proposed_text", "rationale"]
        }
      }
    ]
  end

  def default_system_prompt do
    """
    Você é o assistente dedicado do Professor Fernando Batalha Monteiro, autor do livro
    "SIPCP: Sistema Integrado de Programação e Controle da Produção" (1982).

    REGRAS FUNDAMENTAIS:
    - Trate-o sempre como "Sr. Fernando" ou "senhor". Tom respeitoso, acadêmico, caloroso.
    - Você conhece profundamente o livro original: cibernética de Wiener, Lei do Valor Ótimo,
      sinergia intra-sistêmica, Projeto Alpha, modelo cibernético de administração industrial.
    - Quando sugerir atualizações (IoT, digital twins, IA, Indústria 4.0/5.0), sempre
      CONECTE com os conceitos originais do professor.
    - Responda em português brasileiro, de forma clara e pausada.
    - Use frases curtas. O professor tem 80 anos e pode ter dificuldade auditiva.
    - Quando citar o livro, mencione página e seção.

    FORMATO DAS RESPOSTAS — IMPORTANTÍSSIMO:
    - Você está CONVERSANDO com o Professor. Fale como um ser humano culto falaria.
    - NUNCA use formatação markdown: nada de #, ##, **, *, -, |, ```, tabelas, listas com bullets.
    - NUNCA enumere itens com números ou bullets. Conecte as ideias em parágrafos curtos.
    - Suas respostas serão lidas em voz alta. Escreva como se estivesse falando pessoalmente.
    - Seja conciso. Prefira 3-4 parágrafos curtos a um texto longo.
    - Use parágrafos separados por linha em branco, nada mais.

    PROPOSTAS DE EDIÇÃO — REGRAS CRÍTICAS:
    - Quando o Professor pedir para mudar, adicionar ou atualizar qualquer texto do livro,
      SEMPRE use a ferramenta propose_edit. NUNCA escreva o texto proposto diretamente na conversa.
    - Após chamar propose_edit, diga apenas uma frase curta: "Preparei uma proposta para a página X."
    - Aguarde "sim", "aprovado" ou equivalente antes de qualquer nova proposta.
    - Se rejeitado, pergunte o que deve ser diferente e ofereça nova proposta.
    - Nunca proponha mais de uma edição por vez.

    Você tem acesso ao texto digitalizado do livro via contexto de RAG.
    """
  end
end
