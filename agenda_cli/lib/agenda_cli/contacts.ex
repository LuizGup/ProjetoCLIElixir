defmodule AgendaCli.Contacts do
  @moduledoc """
  Módulo contendo a lógica central e funções puras da Agenda.
  Todas as operações recebem a lista de contatos atual e retornam uma nova lista ou informação.
  A imutabilidade e ausência de side-effects são respeitadas aqui.
  """

  @doc """
  Adiciona um novo contato à lista.
  Gera um ID automaticamente via timestamp em milissegundos.
  """
  def add(contacts, params \\ %{}) do
    id = DateTime.utc_now() |> DateTime.to_unix(:millisecond)

    new_contact = %{
      id: id,
      name: Map.get(params, :name, ""),
      company: Map.get(params, :company, ""),
      phone: Map.get(params, :phone, ""),
      email: Map.get(params, :email, "")
    }

    contacts ++ [new_contact]
  end

  @doc """
  Atualiza os dados de um contato existente com base no ID.
  Retorna a lista completa atualizada.
  """
  def edit(contacts, id, params) do
    Enum.map(contacts, fn
      %{id: ^id} = contact ->
        Map.merge(contact, params)

      contact ->
        contact
    end)
  end

  @doc """
  Remove um contato da lista com base no ID.
  Retorna a lista completa sem o contato.
  """
  def delete(contacts, id) do
    Enum.reject(contacts, fn contact -> contact.id == id end)
  end

  @doc """
  Retorna um contato específico baseado no ID.
  """
  def get(contacts, id) do
    Enum.find(contacts, fn contact -> contact.id == id end)
  end

  @doc """
  Retorna a lista atual de contatos (pode ser útil para pipelines).
  """
  def list(contacts) do
    contacts
  end

  @doc """
  Pesquisa contatos que parcialmente correspondam a um campo específico.
  A busca é case-insensitive.
  Espera uma tupla com chave e valor correspondente, ex: `{:name, "ana"}`.
  """
  def search(contacts, {key, value}) when is_binary(value) do
    search_term = String.downcase(value)

    Enum.filter(contacts, fn contact ->
      field_value = contact |> Map.get(key, "") |> to_string() |> String.downcase()
      String.contains?(field_value, search_term)
    end)
  end
end
