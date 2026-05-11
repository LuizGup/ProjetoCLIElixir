defmodule AgendaCli.Store do
  @moduledoc """
  Responsável pelas operações de I/O (leitura e gravação) da agenda de contatos
  utilizando o arquivo contacts.json. Funções impuras (side-effects).
  """

  @file_name "contacts.json"

  @doc """
  Lê os contatos do arquivo JSON. Se o arquivo não existir ou for inválido, retorna uma lista vazia.
  """
  def load do
    case File.read(@file_name) do
      {:ok, content} ->
        case Jason.decode(content, keys: :atoms) do
          {:ok, contacts} -> contacts
          {:error, _} -> []
        end

      {:error, _} ->
        []
    end
  end

  @doc """
  Salva a lista de contatos em formato JSON.
  """
  def save(contacts) do
    case Jason.encode(contacts, pretty: true) do
      {:ok, json} ->
        File.write(@file_name, json)

      {:error, _} ->
        :error
    end
  end
end
