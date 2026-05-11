defmodule AgendaCli do
  alias AgendaCli.{Store, Contacts}

  @moduledoc """
  Módulo principal que funciona como interface via CLI.
  Utiliza tail-recursion (recursão de cauda) para o loop do programa
  e pattern matching para identificar comandos.
  """

  @doc """
  Ponto de entrada do script compilado.
  """
  def main(_args \\ []) do
    IO.puts("📇 Bem-vindo(a) à Agenda CLI Funcional!")
    contacts = Store.load()
    loop(contacts)
  end

  # --- Loop Recursivo de Cauda ---
  defp loop(contacts) do
    input = IO.gets("agenda> ") |> String.trim()
    process_command(input, contacts)
  end

  # --- Pattern Matching e Execução de Comandos ---
  defp process_command("exit", _contacts) do
    IO.puts("Saindo... 👋")
    :ok
  end

  defp process_command("add " <> args, contacts) do
    params = parse_args(args)
    new_contacts = Contacts.add(contacts, params)
    Store.save(new_contacts)

    IO.puts("✅ Contato adicionado com sucesso!")
    loop(new_contacts)
  end

  defp process_command("edit " <> rest, contacts) do
    [id_str | args_list] = String.split(rest, " ", parts: 2)

    with {id, _} <- Integer.parse(String.trim(id_str)),
         true <- Contacts.get(contacts, id) != nil do

      args = Enum.at(args_list, 0, "")
      params = parse_args(args)
      new_contacts = Contacts.edit(contacts, id, params)

      Store.save(new_contacts)
      IO.puts("✅ Contato #{id} atualizado!")
      loop(new_contacts)
    else
      :error ->
        IO.puts("❌ O ID deve ser numérico.")
        loop(contacts)
      false ->
        IO.puts("❌ Contato não encontrado.")
        loop(contacts)
    end
  end

  defp process_command("del " <> id_str, contacts) do
    case Integer.parse(String.trim(id_str)) do
      {id, _} ->
        if Contacts.get(contacts, id) do
          new_contacts = Contacts.delete(contacts, id)
          Store.save(new_contacts)
          IO.puts("✅ Contato removido.")
          loop(new_contacts)
        else
          IO.puts("❌ Contato não encontrado.")
          loop(contacts)
        end
      :error ->
        IO.puts("❌ O ID deve ser numérico.")
        loop(contacts)
    end
  end

  defp process_command("show " <> id_str, contacts) do
    case Integer.parse(String.trim(id_str)) do
      {id, _} ->
        case Contacts.get(contacts, id) do
          nil -> IO.puts("❌ Contato não encontrado.")
          contact -> print_contact(contact)
        end
      :error -> IO.puts("❌ O ID deve ser numérico.")
    end
    loop(contacts)
  end

  defp process_command("list", contacts) do
    if contacts == [] do
      IO.puts("📂 A agenda está vazia.")
    else
      IO.puts("\n--- Lista de Contatos ---")
      Enum.each(contacts, fn c ->
        IO.puts("[#{c.id}] #{Map.get(c, :name, "")} | Empresa: #{Map.get(c, :company, "")}")
      end)
      IO.puts("-------------------------\n")
    end

    loop(contacts)
  end

  defp process_command("search --" <> rest, contacts) do
    [key_str | value_list] = String.split(rest, " ", parts: 2)
    key = String.to_atom(String.trim(key_str))
    value = Enum.at(value_list, 0, "") |> String.trim()

    results = Contacts.search(contacts, {key, value})

    if results == [] do
      IO.puts("🔍 Nenhum contato encontrado para #{key}: #{value}")
    else
      IO.puts("\n--- Resultados da Busca ---")
      Enum.each(results, fn c -> print_contact(c) end)
      IO.puts("---------------------------\n")
    end

    loop(contacts)
  end

  # Enter vazio
  defp process_command("", contacts), do: loop(contacts)

  # Comando não reconhecido
  defp process_command(cmd, contacts) do
    IO.puts("⚠️  Comando não reconhecido: #{cmd}")
    loop(contacts)
  end

  # --- Utilitários Puros de Parsing e Impressão ---

  @doc """
  Analisa os argumentos.
  Exemplo: "--name Ana --phone 8599" vira %{name: "Ana", phone: "8599"}
  """
  defp parse_args(args_str) do
    ~r/--(\w+)\s+(.*?)(?=\s+--|$)/
    |> Regex.scan(args_str)
    |> Enum.reduce(%{}, fn [_, key, value], acc ->
      Map.put(acc, String.to_atom(key), String.trim(value))
    end)
  end

  defp print_contact(c) do
    IO.puts("""
    -------------------------
    🆔 ID:       #{c.id}
    👤 Nome:     #{Map.get(c, :name, "")}
    🏢 Empresa:  #{Map.get(c, :company, "")}
    📱 Telefone: #{Map.get(c, :phone, "")}
    📧 E-mail:   #{Map.get(c, :email, "")}
    """)
  end
end
