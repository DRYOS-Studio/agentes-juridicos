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
- Um computador com Mac ou Windows. Faça a instalação no computador, não no celular. Não precisa usar
  Terminal nem instalar nada além do VS Code.

## Instalação

1. **Instale o VS Code**, o editor gratuito da Microsoft: baixe em
   [code.visualstudio.com/download](https://code.visualstudio.com/download) e instale com as opções
   padrão.
2. **Instale a extensão Claude Code.** No VS Code, tecle `Cmd + Shift + X` (Mac) ou
   `Ctrl + Shift + X` (Windows), busque "Claude Code" (publicada pela Anthropic) e clique em
   **Install**.
3. **Crie uma pasta para os agentes e abra no VS Code.** Crie a pasta "Agentes jurídicos" em
   Documentos. No VS Code, vá em **File → Open Folder** (Arquivo → Abrir Pasta) e escolha essa
   pasta. É nela que o Claude salva as peças.
4. **Entre com a sua conta.** Clique no ícone do Claude Code (✻) na barra da esquerda e, no painel,
   em **Sign in**. O navegador abre para você entrar com a sua conta do Claude.
5. **Instale os agentes.** Abra [dryos.com.br/agentes-juridicos-obrigado](https://www.dryos.com.br/agentes-juridicos-obrigado#instalar)
   e clique em **Instalar os agentes**. O botão abre o VS Code direto na instalação. O endereço do
   botão é este:
   ```
   vscode://anthropic.claude-code/install-plugin?plugin=agentes-juridicos&marketplace=https%3A%2F%2Fwww.dryos.com.br%2Fplugins%2Fmarketplace.json
   ```
   Se o VS Code perguntar se pode abrir o link, confirme. Se ele pedir para adicionar o catálogo da
   DRYOS, confira que o endereço é `https://www.dryos.com.br/plugins/marketplace.json` e confirme. Depois escolha **Install for you**.

   **Não abriu?** No painel do Claude, digite `/plugins`, vá na aba **Marketplaces**, cole o
   endereço abaixo e confirme. Depois, na aba **Plugins**, clique em **Install** em
   `agentes-juridicos` e escolha **Install for you**.
   ```
   https://www.dryos.com.br/plugins/marketplace.json
   ```

## Fazer o teste

Cole a mensagem abaixo no painel do Claude, no VS Code. O caso é fictício; não use dados de cliente real no teste.

<!-- teste:inicio -->
```
Use o agente divorcio-consensual. Caso fictício para teste: Ana Souza e Bruno Lima, casados desde 2015 no regime de comunhão parcial, sem filhos, querem se divorciar em cartório. Têm um apartamento em Niterói (R$ 400.000) que fica com Ana, que paga R$ 200.000 a Bruno. Sem pensão entre eles. Redija a minuta da escritura.
```
<!-- teste:fim -->

O Claude passa o pedido para o agente, que pode fazer perguntas antes de redigir e depois entrega a
minuta com as averbações e o checklist.

Para chamar outro agente, diga o nome dele no pedido, por exemplo: "Use o agente bpc-loas para…".

## Perguntas frequentes

**O Claude avisou que a conta não foi conferida por código.** Os agentes de cálculo conferem a
conta com o Python. Sem ele, fazem a conta no texto e avisam. Para conferir, peça ao Claude
"instale o Python". Ele pede permissão antes de instalar. Depois de instalar no Windows, feche e abra o
VS Code.

**E o sigilo dos meus clientes?** O que você digita no Claude Code vai para os servidores da
Anthropic, a empresa que faz o Claude. Anonimize nomes e documentos quando puder e siga a política
do seu escritório.

**O Claude pediu permissão para rodar um comando.** Os agentes só precisam instalar e rodar o Python
(para cálculos) e criar arquivos da peça na pasta dos agentes. Não aprove comandos que você não entende,
e não abra no Claude Code documentos de origem desconhecida.

**Prefiro o terminal.** Com o Claude Code de terminal instalado ([claude.ai/install](https://code.claude.com/docs/en/setup)), rode
`claude plugin marketplace add https://www.dryos.com.br/plugins/marketplace.json` e depois
`claude plugin install agentes-juridicos@dryos`.

## Quer a rotina do escritório automatizada?

Os agentes redigem a peça. A DRYOS automatiza a rotina em volta dela: atendimento no WhatsApp,
cobrança de honorários, sistemas conectados e relatórios. Diagnóstico gratuito de 30 minutos:
[dryos.com.br](https://dryos.com.br) · contato@dryos.com.br

---

Uso permitido para avaliação e uso profissional pelo escritório. Não redistribuir sem autorização da DRYOS.
