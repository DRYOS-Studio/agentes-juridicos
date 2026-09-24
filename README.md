# Agentes jurídicos DRYOS para o Claude Code

8 agentes de IA que redigem peças para escritórios de advocacia, 2 por área:

| Área | Agente | O que entrega |
|---|---|---|
| Trabalhista | `reclamacao-trabalhista-inicial` | Reclamação com pedido líquido (CLT 840) |
| Trabalhista | `calculo-verbas-rescisorias` | Cálculo das verbas da rescisão, por tipo de desligamento |
| Previdenciário | `aposentadoria-tempo-contribuicao` | Análise das regras de transição da EC 103/2019 e requerimento |
| Previdenciário | `bpc-loas` | Requerimento e ação de BPC/LOAS |
| Família | `divorcio-consensual` | Minuta de divórcio consensual extrajudicial |
| Família | `acao-alimentos` | Ação de alimentos (necessidade × possibilidade) |
| Consumidor | `acao-cdc-pratica-abusiva` | Ação contra prática abusiva (CDC 39 e 51) |
| Consumidor | `acao-vicio-produto-servico` | Ação por vício ou defeito de produto ou serviço |

O que eles produzem é **rascunho**. O advogado revisa e assina, e a responsabilidade técnica é dele
(EAOAB, art. 32).

## Antes de começar

- **Plano pago do Claude** (Pro ou superior). O plano gratuito não inclui o Claude Code.
- Um computador com Mac ou Windows.

## Instalação no Mac

1. Abra o **Terminal**: tecle `Cmd + Espaço`, digite "Terminal" e aperte Enter.
2. Instale as ferramentas de linha de comando da Apple, que trazem o git e o Python:
   ```
   xcode-select --install
   ```
   Uma janela vai pedir confirmação. Clique em **Instalar** e espere terminar. Se aparecer
   "already installed", pode seguir.
3. Instale o Claude Code:
   ```
   curl -fsSL https://claude.ai/install.sh | bash
   ```
4. Crie uma pasta só para os agentes e entre nela:
   ```
   mkdir -p ~/agentes-juridicos && cd ~/agentes-juridicos
   ```
5. Siga para **Instalar os agentes**.

## Instalação no Windows

1. Instale o **Git for Windows**: baixe em [git-scm.com/downloads/win](https://git-scm.com/downloads/win) e avance com as opções padrão.
2. Instale o **Python** pela Microsoft Store: abra a Store, busque "Python 3" (publicado pela Python Software Foundation) e clique em **Obter**.
3. Abra o **PowerShell**: tecle `Windows`, digite "PowerShell" e aperte Enter.
4. Instale o Claude Code:
   ```
   irm https://claude.ai/install.ps1 | iex
   ```
5. Feche e abra o PowerShell de novo. Crie uma pasta só para os agentes e entre nela:
   ```
   mkdir -Force $HOME\agentes-juridicos; cd $HOME\agentes-juridicos
   ```
6. Siga para **Instalar os agentes**.

## Instalar os agentes

1. Abra o Claude Code na pasta que você criou:
   ```
   claude
   ```
   Na primeira vez, o navegador abre para você entrar com a sua conta do Claude.
2. Dentro do Claude Code, adicione o catálogo da DRYOS:
   ```
   /plugin marketplace add DRYOS-Studio/agentes-juridicos
   ```
3. Instale os agentes e, quando o Claude perguntar, escolha **User scope**:
   ```
   /plugin install agentes-juridicos@dryos
   ```
4. Para conferir, digite `/plugin`, vá até a aba **Installed** e veja `agentes-juridicos` na lista.
   Tecle `Esc` para sair.

## Fazer o teste

Cole a mensagem abaixo no Claude Code. O caso é fictício; não use dados de cliente real no teste.

<!-- teste:inicio -->
```
Use o agente divorcio-consensual. Caso fictício para teste: Ana Souza e Bruno Lima, casados desde 2015 no regime de comunhão parcial, sem filhos, querem se divorciar em cartório. Têm um apartamento em Niterói (R$ 400.000) que fica com Ana, que paga R$ 200.000 a Bruno. Sem pensão entre eles. Redija a minuta da escritura.
```
<!-- teste:fim -->

O Claude passa o pedido para o agente, que pode fazer perguntas antes de redigir e depois entrega a
minuta com as averbações e o checklist.

Para chamar outro agente, diga o nome dele no pedido, por exemplo: "Use o agente bpc-loas para…".

## Perguntas frequentes

**Apareceu "python3: command not found" ou "python3 não é reconhecido".** Os agentes de cálculo
usam o Python. No Mac, rode `xcode-select --install` de novo. No Windows, instale o Python pela
Microsoft Store (passo 2), feche e abra o PowerShell. Se ainda falhar, peça ao Claude: "faça a conta
sem usar Python".

**E o sigilo dos meus clientes?** O que você digita no Claude Code vai para os servidores da
Anthropic, a empresa que faz o Claude. Anonimize nomes e documentos quando puder e siga a política
do seu escritório.

**O Claude pediu permissão para rodar um comando.** Os agentes só precisam rodar `python3` (para
cálculos) e criar arquivos da peça na pasta dos agentes. Não aprove comandos que você não entende,
e não abra no Claude Code documentos de origem desconhecida.

**Deu "/plugin isn't available in this environment".** Você está no app de desktop ou numa sessão
na nuvem. Use o Terminal (Mac) ou o PowerShell (Windows), como no passo a passo.

**Como atualizo?** Rode `/plugin marketplace update dryos` dentro do Claude Code.

## Quer a rotina do escritório automatizada?

Os agentes redigem a peça. A DRYOS automatiza a rotina em volta dela: atendimento no WhatsApp,
cobrança de honorários, sistemas conectados e relatórios. Diagnóstico gratuito de 30 minutos:
[dryos.com.br](https://dryos.com.br) · contato@dryos.com.br

---

Uso permitido para avaliação e uso profissional pelo escritório. Não redistribuir sem autorização da DRYOS.
