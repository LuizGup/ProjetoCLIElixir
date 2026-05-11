# AgendaCli - Projeto Elixir

**Repositório:** [Adicione o link do GitHub aqui]

Aplicação de Linha de Comando (CLI) para gerenciamento de contatos, escrita puramente em **Elixir**.

> Avaliação Prática da disciplina **T300 — Programação Funcional** (UNIFOR), Prof. Bruno Lopes.
> Demonstra os pilares da programação funcional: pipe operator, pattern matching, recursão de cauda (tail recursion), imutabilidade e separação entre funções puras e side-effects.

---

## Pré-requisitos

- **Elixir** 1.19+
- **Mix** (gerenciador incluído na instalação padrão do Elixir)
- Biblioteca **Jason** (já mapeada nas dependências para lidar com o `contacts.json`)

---

## Instalação e configuração

### 1. Clone o repositório e baixe as dependências

Se ainda não fez o clone:

```powershell
git clone <url-do-repo>
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

