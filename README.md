# Agenda de Contatos - Projeto Elixir (CLI)

**Repositório:** [https://github.com/LuizGup/ProjetoCLIElixir](https://github.com/LuizGup/ProjetoCLIElixir)

Este projeto é uma aplicação de linha de comando interativa (CLI) dedicada ao gerenciamento prático de contatos pessoais. Inteiramente codificado em **Elixir**, o sistema foi desenvolvido como requisito prático e avaliativo da disciplina de **Programação Funcional** (T300), lecionada pelo Prof. Bruno Lopes na **Universidade de Fortaleza (UNIFOR)**.

O objetivo acadêmico primário da implementação é demonstrar a aplicabilidade real dos paradigmas funcionais aplicados ao _Elixir_. Todo o núcleo da aplicação segue diretrizes rigorosas:
* **Recursão de Cauda (Tail Recursion):** Utilizada no controle do loop da aplicação descartando varáveis globais ou modificadores mutáveis.
* **Pattern Matching:** Utilizado na captura elegante e processamento de comandos recebidos na CLI contornando a complexidade de rotinas longas e IF/SWITCHs.
* **Funções Puras x Impuras:** Separação clara entre a lógica de persistência e a lógica de mutação de listas funcionais.
* **Pipe Operator (`|>`):** Encadeamento legível de informações e processamentos.

---

## Tecnologias Integradas

- **Elixir (v1.19+)**: Linguagem principal na qual toda a regra de negócios funcional roda.
- **Mix**: Compilador, gerenciador de tarefas e de pacotes, nativo do ecossistema do Elixir.
- **Jason**: Biblioteca acoplada na dependência para realizar de maneira otimizada o Parse e Encoding da Serialização JSON no backend.

---

## A Estrutura do Contato

Cada registro persistido no programa molda um Mapa com os seguintes identificadores:

* **ID**: Único; estabelecido através da leitura exata do momento e Timestamp em Milissegundos (`UTC`).
* **Nome**: Referência ou o nome completo associado a pessoa (`--name`).
* **Empresa**: Organização de registro ou local de trabalho desse contato (`--company`).
* **Telefone**: Formatação aberta a código de país ou estado (`--phone`).
* **E-mail**: Endereço eletrônico validado ou link de acesso virtual (`--email`).

---

## Pré-requisitos

- **Elixir** 1.15+ / **Erlang/OTP** 26+
- **Mix** (gerenciador incluído na instalação padrão)
- Biblioteca **Jason** (já mapeada no `mix.exs`)

---

## Instalação e configuração

### 1. Clone o repositório e baixe as dependências

Se ainda não fez o clone:

```powershell
git clone https://github.com/LuizGup/ProjetoCLIElixir.git
cd ProjetoCLIElixir/agenda_cli
mix deps.get
```

### 2. Inicie o sistema

No terminal, execute o comando abaixo para iniciar a CLI de forma interativa através do Mix:

```powershell
mix run -e "AgendaCli.main()"
```

*(Ao rodá-lo pela primeira vez, uma nova base de dados persistente `contacts.json` será inicializada automaticamente ao adicionar novos registros).*

---

## Comandos disponíveis na CLI

Aqui está a lista de funções quando a prompt `agenda> ` surgir:

| Comando | Descrição | Exemplo de Uso |
|---------|-----------|----------------|
| `add` | Adiciona um novo contato. | `add --name Ana --company Acme --phone 85912345678 --email ana@acme.com` |
| `edit <id>` | Atualiza um ou mais campos de um contato. | `edit 123 --phone 85999999999 --company NovaCompany` |
| `del <id>` | Remove o contato da agenda com base no ID. | `del 123` |
| `show <id>`| Mostra todas as informações de um único contato. | `show 123` |
| `list` | Lista todos os contatos num resumo limpo. | `list` |
| `search` | Pesquisa (case-insensitive) e parcial. | `search --name ana` ou `search --phone 85` |
| `exit` | Encerra e sai do app. | `exit` |

---

## Arquitetura (Limpa e Funcional)

O sistema foi rigorosamente quebrado em pequenos módulos com funções únicas.

```text
lib/
├── agenda_cli.ex           # (Main) Inicializa, faz o `loop` (tail recursion) e o parse CLI via pattern match
├── agenda_cli/
│   ├── contacts.ex         # Funções puras: processam (add, edit, list) e não tocam ou alteram estados
│   └── store.ex            # Funções impuras: lê e transcreve a agenda para `contacts.json` (Usando Jason)
```

---

## Persistência de Dados Direta

Para manter a imutabilidade do registro, mas permitir seu desligamento sem perda, toda operação bem-sucedida de manipulação das listas (inclusão, alteração ou deleção) processa as novas matrizes e as converte no formato JSON.
Essa substituição grava automaticamente os dados na raiz do seu projeto no arquivo `contacts.json`. O isolamento dessa "função impura" foi feito para evitar qualquer interrupção/corrupção no looping puro de listagem da memória virtual gerada pelo interpretador.

---

## Licença Acadêmica

Código distribuído para escopos abertos com propósitos avaliativos do aluno e análise aberta da disciplina abordada (UNIFOR, T300). Sinta-se à vontade para revisar as funções e estudar os _Pattern Matchings_ documentados!

