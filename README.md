# Sistema de Gestão de Seguros – Banco de Dados

Um projeto completo de modelagem e implementação de um banco de dados relacional para gestão de apólices de seguros, desenvolvido em SQL Server. Inclui scripts de criação, inserção de dados, views analíticas e documentação detalhada.

## Autoria

Este projeto foi desenvolvido no âmbito da cadeira Bases de Dados, lecionada pela profª Marta Martinho, no programa UPskill ServiceNow por:

<p align="center">
	<a href="https://github.com/gongabriela">
		<img src="https://github.com/gongabriela.png" width="100px" style="border-radius:50%;" />
	</a>
	<a href="https://github.com/danielarjordao">
		<img src="https://github.com/danielarjordao.png" width="100px" style="border-radius:50%;" />
	</a>
</p>

<p align="center">
	<a href="https://github.com/gongabriela">Gabriela Oliveira</a> ·
	<a href="https://github.com/danielarjordao">Daniela Jordão</a>
</p>

## Características

- **Modelagem relacional completa**: Tabelas, relacionamentos, tipos personalizados e regras de integridade
- **Scripts SQL organizados**: Criação, views, inserção de dados e consultas analíticas
- **Relatórios estratégicos**: Views para análise de contratos, prêmios, clientes, sinistros e performance
- **Documentação detalhada**: Dicionário de dados e relatório final em HTML
- **Exemplo de dados**: Script de inserção para testes e demonstração

## Estrutura do Projeto

```
BD_GestaoDeSeguros/
├── srcs/
│   ├── gestaoDeSeguros.sql        # Criação do banco, tabelas e tipos
│   ├── createViews.sql            # Criação das views analíticas
│   ├── inserirDados.sql           # Inserção de dados de exemplo
│   └── queries.sql                # Consultas SQL para relatórios
├── docs/
│   ├── dicionario_de_dados.html   # Dicionário de dados completo
│   ├── Dicionário de Dados - Gestão de Seguros.pdf
│   ├── relatorio_final.html       # Relatório acadêmico e justificativas
│   ├── schema-GestaoDeSegurosFinal.png # Esquema relacional (imagem)
│   └── Trabalho Final - Gestão de Seguros.pdf
├── Trabalho_Pratico_BD_Upskill_v1.pdf # Enunciado do trabalho
└── README.md                      # Este arquivo
```

## Como Usar

### Pré-requisitos
- SQL Server 2019 ou superior (ou compatível)
- Ferramenta de administração (SSMS, Azure Data Studio, etc.)

### Execução dos Scripts
1. Execute `gestaoDeSeguros.sql` para criar o banco de dados, tabelas, tipos e regras
2. Execute `createViews.sql` para criar as views analíticas
3. Execute `inserirDados.sql` para popular o banco com dados de exemplo
4. Utilize `queries.sql` para gerar relatórios e análises

> **Dica:** Consulte o `dicionario_de_dados.html` para detalhes de cada tabela, campo e relacionamento.

## Principais Entidades

- **EntidadePessoa**: Clientes (pessoas físicas ou jurídicas)
- **EntidadeBem**: Bens segurados (veículos, imóveis, etc.)
- **Seguradora**: Empresas emissoras de apólices
- **Mediador**: Agentes intermediários
- **Apolice**: Contratos de seguro
- **Premio**: Valores contratados e periodicidade
- **Pagamento**: Registros de pagamentos efetuados
- **Sinistro**: Ocorrências e indenizações
- **Histórico**: Tabelas de auditoria para apólices e sinistros

## Relatórios e Views

- Contratos por tipo de seguro
- Seguradoras e número de contratos ativos
- Valor médio do prêmio por tipo de seguro
- Clientes e número de contratos celebrados
- Pagamentos por contrato
- Volume financeiro por seguradora
- Exposição ao risco (contratos com mais sinistros)
- Histórico de apólices

## Documentação

- `dicionario_de_dados.html`: Estrutura detalhada do banco, tipos, restrições e relacionamentos
- `relatorio_final.html`: Justificativas de modelagem, decisões de negócio e exemplos de uso

## Regras de Negócio

- Valores monetários não podem ser negativos (regra RL_ValoresMonetarios)
- Integridade referencial garantida por chaves estrangeiras
- Estados e tipos controlados por restrições CHECK
- Histórico de alterações preservado em tabelas-espelho
- Cada apólice deve estar vinculada a um mediador e seguradora

## Projeto Educacional

Desenvolvido como projeto acadêmico para a disciplina de Bases de Dados | 2026
