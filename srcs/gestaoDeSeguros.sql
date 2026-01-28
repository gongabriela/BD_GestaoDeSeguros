-- Criação do banco de dados
-- Cria o banco 'GestaoDeSeguros' se não existir.
USE [master]
GO

-- Cria o banco GestaoDeSeguros caso não exista
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'GestaoDeSeguros')
BEGIN
    CREATE DATABASE [GestaoDeSeguros]
END
GO

-- Seleciona o banco GestaoDeSeguros para uso
USE [GestaoDeSeguros]
GO

-- Limpeza de objetos existentes
-- Remove tabelas, views e objetos dependentes para recriação limpa.
DROP TABLE IF EXISTS [HistoricoSinistro];
DROP TABLE IF EXISTS [Sinistro];
DROP TABLE IF EXISTS [Pagamento];
DROP TABLE IF EXISTS [Premio];
DROP TABLE IF EXISTS [HistoricoApolice];
DROP TABLE IF EXISTS [ApoliceEntidadeBem];
DROP TABLE IF EXISTS [ApoliceEntidadePessoa];
DROP TABLE IF EXISTS [Apolice];
DROP TABLE IF EXISTS [CoberturaProdutoPlano];
DROP TABLE IF EXISTS [CoberturaPlano];
DROP TABLE IF EXISTS [ProdutoPlano];
DROP TABLE IF EXISTS [Produto];
DROP TABLE IF EXISTS [TipoDeSeguro];
DROP TABLE IF EXISTS [MediadorSeguradora];
DROP TABLE IF EXISTS [Mediador];
DROP TABLE IF EXISTS [Seguradora];
DROP TABLE IF EXISTS [EntidadeBem];
DROP TABLE IF EXISTS [EntidadePessoa];
DROP VIEW IF EXISTS vw_RelatorioValorTotalPremiosPorSeguradora;
DROP VIEW IF EXISTS vw_ContratosEExistenciaDeSinistros;
DROP VIEW IF EXISTS vw_ContratosPorTipoDeSeguro;
DROP VIEW IF EXISTS vw_SeguradorasENumeroDeContratosAtivos;
DROP VIEW IF EXISTS vw_ValorMedioDoPremioPorTipoDeSeguro;
DROP VIEW IF EXISTS vw_ClientesENumeroDeContratosCelebrados;
DROP VIEW IF EXISTS vw_RelatorioPagamentosPorContrato;
DROP VIEW IF EXISTS vw_HistoricoApolice;
GO

-- Regras e tipos de dados personalizados
-- Remove e (re)cria objetos que padronizam valores monetários no esquema.
-- `RL_ValoresMonetarios`: regra que garante valores monetários não-negativos.
-- `Dom_Moeda`: tipo decimal com precisão (10,2) utilizado para valores monetários.
IF TYPE_ID('Dom_Moeda') IS NOT NULL
BEGIN
    EXEC sp_unbindrule 'Dom_Moeda';
END
IF OBJECT_ID('RL_ValoresMonetarios', 'R') IS NOT NULL
    DROP RULE RL_ValoresMonetarios;
GO
IF TYPE_ID('Dom_Moeda') IS NOT NULL
    DROP TYPE Dom_Moeda;
GO

CREATE RULE RL_ValoresMonetarios AS @val >= 0;
GO

CREATE TYPE Dom_Moeda FROM DECIMAL(10,2) NOT NULL;
GO

EXEC sp_bindrule 'RL_ValoresMonetarios', 'Dom_Moeda';
GO


/*
EntidadePessoa
Regista pessoas físicas e jurídicas que podem atuar como clientes, tomadores ou segurados.
Campos:
- EntidadePessoaID (PK) - SMALLINT AUTO_INCREMENT
- Nome - VARCHAR(100) NOT NULL
- NIF - CHAR(9) NOT NULL UNIQUE
- TipoEntidade - VARCHAR(20) NOT NULL ('Pessoa Física', 'Pessoa Jurídica')
- DataNascimento - DATE NOT NULL
- Morada - VARCHAR(200) NOT NULL
- Localidade - VARCHAR(100) NOT NULL
- Telefone - CHAR(15) NOT NULL
- Email - VARCHAR(100) NOT NULL
- Status - VARCHAR(10) NOT NULL ('Ativo', 'Inativo')
- Observacoes - VARCHAR(200)
*/
CREATE TABLE EntidadePessoa (
    EntidadePessoaID SMALLINT PRIMARY KEY IDENTITY(1,1),
    Nome VARCHAR(100) NOT NULL,
    NIF CHAR(9) NOT NULL UNIQUE,
    TipoEntidade VARCHAR(20) NOT NULL CHECK (TipoEntidade IN ('Pessoa Física', 'Pessoa Jurídica')),
    DataNascimento DATE NOT NULL,
    Morada VARCHAR(200) NOT NULL,
    Localidade VARCHAR(100) NOT NULL,
    Telefone CHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Status VARCHAR(10) NOT NULL CHECK (Status IN ('Ativo', 'Inativo')),
    Observacoes VARCHAR(200)
);

/*
EntidadeBem
Regista bens pertencentes a pessoas físicas ou jurídicas.
Campos:
- EntidadeBemID (PK) - INT AUTO_INCREMENT
- ProprietarioID (FK) - SMALLINT NOT NULL (referência a `EntidadePessoa`)
- DescricaoBem - VARCHAR(200) NOT NULL
- IdentificacaoBem - VARCHAR(100) NOT NULL UNIQUE
- ValorEstimado - Dom_Moeda (estimativa do valor do bem)
- DataAquisicao - DATE NOT NULL
- Observacoes - VARCHAR(200)
*/
CREATE TABLE EntidadeBem (
    EntidadeBemID INT PRIMARY KEY IDENTITY(1,1),
    ProprietárioID SMALLINT NOT NULL REFERENCES EntidadePessoa(EntidadePessoaID),
    DescricaoBem VARCHAR(200) NOT NULL,
    IdentificacaoBem VARCHAR(100) NOT NULL UNIQUE,
    ValorEstimado Dom_Moeda,
    DataAquisicao DATE NOT NULL,
    Observacoes VARCHAR(200)
);

/*
Seguradora
Regista as empresas seguradoras presentes no sistema.
Campos:
- SeguradoraID (PK) - SMALLINT AUTO_INCREMENT
- Nome - VARCHAR(100) NOT NULL
- NIF - CHAR(9) NOT NULL UNIQUE
- Morada - VARCHAR(200) NOT NULL
- Localidade - VARCHAR(100) NOT NULL
- Email - VARCHAR(100) NOT NULL
- Telefone - CHAR(15) NOT NULL
- Status - VARCHAR(10) NOT NULL ('Ativa', 'Inativa')
- Observacoes - VARCHAR(200)
*/
CREATE TABLE Seguradora (
    SeguradoraID SMALLINT PRIMARY KEY IDENTITY(1,1),
    Nome VARCHAR(100) NOT NULL,
    NIF CHAR(9) NOT NULL UNIQUE,
    Morada VARCHAR(200) NOT NULL,
    Localidade VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Telefone CHAR(15) NOT NULL,
    Status VARCHAR(10) NOT NULL CHECK (Status IN ('Ativa', 'Inativa')),
    Observacoes VARCHAR(200)
);

/*
Mediador
Regista mediadores de seguros (pessoas ou empresas que intermediam apólices).
Campos:
- MediadorID (PK) - SMALLINT AUTO_INCREMENT
- Nome - VARCHAR(100) NOT NULL
- NIF - CHAR(9) NOT NULL UNIQUE
- Morada - VARCHAR(200) NOT NULL
- Localidade - VARCHAR(100) NOT NULL
- Email - VARCHAR(100) NOT NULL
- Telefone - CHAR(15) NOT NULL
- Status - VARCHAR(10) NOT NULL ('Ativo', 'Inativo')
- Observacoes - VARCHAR(200)
*/
CREATE TABLE Mediador (
    MediadorID SMALLINT PRIMARY KEY IDENTITY(1,1),
    Nome VARCHAR(100) NOT NULL,
    NIF CHAR(9) NOT NULL UNIQUE,
    Morada VARCHAR(200) NOT NULL,
    Localidade VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Telefone CHAR(15) NOT NULL,
    Status VARCHAR(10) NOT NULL CHECK (Status IN ('Ativo', 'Inativo')),
    Observacoes VARCHAR(200)
);

/*
Associação entre mediadores e seguradoras, com vigência e status.
Campos:
- MediadorID (PK)(FK) - SMALLINT NOT NULL (referência a `Mediador`)
- SeguradoraID (PK)(FK) - SMALLINT NOT NULL (referência a `Seguradora`)
- DataInicio - DATE NOT NULL
- DataFim - DATE
- Status - VARCHAR(10) NOT NULL ('Ativo', 'Inativo')
- Observacoes - VARCHAR(200)
Chave primária composta: (MediadorID, SeguradoraID)
*/
CREATE TABLE MediadorSeguradora (
    MediadorID SMALLINT NOT NULL REFERENCES Mediador(MediadorID),
    SeguradoraID SMALLINT NOT NULL REFERENCES Seguradora(SeguradoraID),
    DataInicio DATE NOT NULL,
    DataFim DATE,
    Status VARCHAR(10) NOT NULL CHECK (Status IN ('Ativo', 'Inativo')),
    Observacoes VARCHAR(200),
    PRIMARY KEY (MediadorID, SeguradoraID)
);

/*
TipoDeSeguro
Tipos de seguro disponíveis.
Campos:
- TipoSeguroID (PK) - SMALLINT AUTO_INCREMENT
- Descricao - VARCHAR(100) NOT NULL
- Observacoes - VARCHAR(200)
*/
CREATE TABLE TipoDeSeguro (
    TipoSeguroID SMALLINT PRIMARY KEY IDENTITY(1,1),
    Descricao VARCHAR(100) NOT NULL,
    Observacoes VARCHAR(200)
);

/*
Produto
Produtos de seguro oferecidos por seguradoras (ligados a um tipo de seguro).
Campos:
- ProdutoID (PK) - SMALLINT AUTO_INCREMENT
- SeguradoraID (FK) - SMALLINT NOT NULL
- TipoSeguroID (FK) - SMALLINT NOT NULL
- NomeProduto - VARCHAR(100) NOT NULL
- Status - VARCHAR(15) NOT NULL ('Ativo', 'Descontinuado')
- Observacoes - VARCHAR(200)
*/
CREATE TABLE Produto (
    ProdutoID SMALLINT PRIMARY KEY IDENTITY(1,1),
    SeguradoraID SMALLINT NOT NULL REFERENCES Seguradora(SeguradoraID),
    TipoSeguroID SMALLINT NOT NULL REFERENCES TipoDeSeguro(TipoSeguroID),
    NomeProduto VARCHAR(100) NOT NULL,
    Status VARCHAR(15) NOT NULL CHECK (Status IN ('Ativo', 'Descontinuado')),
    Observacoes VARCHAR(200)
);

/*
ProdutoPlano
Planos específicos de um produto de seguro (coberturas e vigência).
Campos:
- ProdutoPlanoID (PK) - INT AUTO_INCREMENT
- ProdutoID (FK) - SMALLINT NOT NULL
- NomePlano - VARCHAR(100) NOT NULL
- DataInicioVigencia - DATE NOT NULL
- DataFimVigencia - DATE
- Observacoes - VARCHAR(200)
*/
CREATE TABLE ProdutoPlano (
    ProdutoPlanoID INT PRIMARY KEY IDENTITY(1,1),
    ProdutoID SMALLINT NOT NULL REFERENCES Produto(ProdutoID),
    NomePlano VARCHAR(100) NOT NULL,
    DataInicioVigencia DATE NOT NULL,
    DataFimVigencia DATE,
    Observacoes VARCHAR(200)
);

/*
CoberturaPlano
Define coberturas específicas disponíveis em um plano de produto.
Campos:
- CoberturaPlanoID (PK) - INT AUTO_INCREMENT
- ProdutoPlanoID (FK) - INT NOT NULL (referência a `ProdutoPlano`)
- DescricaoCobertura - VARCHAR(200) NOT NULL
- LimiteCobertura - Dom_Moeda
- Franquia - Dom_Moeda
- Observacoes - VARCHAR(200)
*/
CREATE TABLE CoberturaPlano (
    CoberturaPlanoID INT PRIMARY KEY IDENTITY(1,1),
    ProdutoPlanoID INT NOT NULL REFERENCES ProdutoPlano(ProdutoPlanoID),
    DescricaoCobertura VARCHAR(200) NOT NULL,
    LimiteCobertura Dom_Moeda,
    Franquia Dom_Moeda,
    Observacoes VARCHAR(200)
);

/*
CoberturaProdutoPlano
Associação entre coberturas e planos, indicando quais coberturas pertencem a cada plano.
Campos:
- CoberturaProdutoPlanoID (PK) - INT AUTO_INCREMENT
- ProdutoPlanoID (FK) - INT NOT NULL
- CoberturaPlanoID (FK) - INT NOT NULL
*/
CREATE TABLE CoberturaProdutoPlano (
    CoberturaProdutoPlanoID INT PRIMARY KEY IDENTITY(1,1),
    ProdutoPlanoID INT NOT NULL REFERENCES ProdutoPlano(ProdutoPlanoID),
    CoberturaPlanoID INT NOT NULL REFERENCES CoberturaPlano(CoberturaPlanoID)
);

/*
Apolice
Regista apólices emitidas para planos de produto.
Campos:
- ApoliceID (PK) - INT AUTO_INCREMENT
- ProdutoPlanoID (FK) - INT NOT NULL (referência a `ProdutoPlano`)
- MediadorID (FK) - SMALLINT NOT NULL (referência a `Mediador`)
- DataEmissao - DATE NOT NULL
- DataInicioVigencia - DATE NOT NULL
- DataFimVigencia - DATE NOT NULL
*/
CREATE TABLE Apolice (
    ApoliceID INT PRIMARY KEY IDENTITY(1,1),
    ProdutoPlanoID INT NOT NULL REFERENCES ProdutoPlano(ProdutoPlanoID),
    MediadorID SMALLINT NOT NULL REFERENCES Mediador(MediadorID),
    DataEmissao DATE NOT NULL DEFAULT GETDATE(),
    DataInicioVigencia DATE NOT NULL,
    DataFimVigencia DATE NOT NULL
);

/*
ApoliceEntidadePessoa
Associação entre apólices e pessoas (tomador, segurado, beneficiário).
Campos:
- ApoliceEntidadeID (PK) - INT AUTO_INCREMENT
- ApoliceID (FK) - INT NOT NULL (referência a `Apolice`)
- EntidadePessoaID (FK) - SMALLINT NOT NULL (referência a `EntidadePessoa`)
- Papel - VARCHAR(15) NOT NULL ('Tomador', 'Segurado', 'Beneficiário')
*/
CREATE TABLE ApoliceEntidadePessoa (
    ApoliceEntidadeID INT PRIMARY KEY IDENTITY(1,1),
    ApoliceID INT NOT NULL REFERENCES Apolice(ApoliceID),
    EntidadePessoaID SMALLINT NOT NULL REFERENCES EntidadePessoa(EntidadePessoaID),
    Papel VARCHAR(15) NOT NULL CHECK (Papel IN ('Tomador', 'Segurado', 'Beneficiário'))
);

/*
ApoliceEntidadeBem
Associação entre apólices e bens segurados.
Campos:
- ApoliceEntidadeBemID (PK) - INT AUTO_INCREMENT
- ApoliceID (FK) - INT NOT NULL (referência a `Apolice`)
- EntidadeBemID (FK) - INT NOT NULL (referência a `EntidadeBem`)
*/
CREATE TABLE ApoliceEntidadeBem (
    ApoliceEntidadeBemID INT PRIMARY KEY IDENTITY(1,1),
    ApoliceID INT NOT NULL REFERENCES Apolice(ApoliceID),
    EntidadeBemID INT NOT NULL REFERENCES EntidadeBem(EntidadeBemID)
);

/*
HistoricoApolice
Regista alterações de estado e eventos relevantes de uma apólice ao longo do tempo.
Campos:
- HistoricoApoliceID (PK) - INT AUTO_INCREMENT
- ApoliceID (FK) - INT NOT NULL (referência a `Apolice`)
- DataAlteracao - DATETIME NOT NULL (data/hora da alteração; default = data atual)
- Estado - VARCHAR(15) NOT NULL ('Ativa', 'Suspensa', 'Cancelada', 'Expirada')
- DescricaoAlteracao - VARCHAR(200) NOT NULL
*/
CREATE TABLE HistoricoApolice (
    HistoricoApoliceID INT PRIMARY KEY IDENTITY(1,1),
    ApoliceID INT NOT NULL REFERENCES Apolice(ApoliceID),
    DataAlteracao DATETIME NOT NULL DEFAULT GETDATE(),
    Estado VARCHAR(15) NOT NULL CHECK (Estado IN ('Ativa', 'Suspensa', 'Cancelada', 'Expirada')),
    DescricaoAlteracao VARCHAR(200) NOT NULL
);

/*
Premio
Valores contratados (prémios) correspondentes a apólices.
Campos:
- PremioID (PK) - INT AUTO_INCREMENT
- ApoliceID (FK) - INT NOT NULL UNIQUE (cada apólice tem, por exemplo, um prémio padrão)
- ValorContratado - Dom_Moeda
- Periodicidade - VARCHAR(15) NOT NULL ('Mensal', 'Trimestral', 'Semestral', 'Anual')
- DataVencimento - DATE NOT NULL
- Observacoes - VARCHAR(200)
*/
CREATE TABLE Premio (
    PremioID INT PRIMARY KEY IDENTITY(1,1),
    ApoliceID INT NOT NULL UNIQUE REFERENCES Apolice(ApoliceID), -- Adicionado UNIQUE conforme sua alteração
    ValorContratado Dom_Moeda,
    Periodicidade VARCHAR(15) NOT NULL CHECK (Periodicidade IN ('Mensal', 'Trimestral', 'Semestral', 'Anual')),
    DataVencimento DATE NOT NULL,
    Observacoes VARCHAR(200)
);

/*
Pagamento
Regista pagamentos efetuados relativos a prêmios.
Campos:
- PagamentoID (PK) - INT AUTO_INCREMENT
- PremioID (FK) - INT NOT NULL (referência a `Premio`)
- DataPagamento - DATE NOT NULL
- ValorPago - Dom_Moeda
- MetodoPagamento - VARCHAR(20) NOT NULL ('Multibanco', 'Cartão de Crédito', 'Débito Direto', 'Dinheiro')
*/
CREATE TABLE Pagamento (
    PagamentoID INT PRIMARY KEY IDENTITY(1,1),
    PremioID INT NOT NULL REFERENCES Premio(PremioID),
    DataPagamento DATE NOT NULL,
    ValorPago Dom_Moeda,
    MetodoPagamento VARCHAR(20) NOT NULL CHECK (MetodoPagamento IN ('Multibanco', 'Cartão de Crédito', 'Débito Direto', 'Dinheiro'))
);

/*
Sinistro
Regista sinistros (ocorrências) associados a apólices.
Campos:
- SinistroID (PK) - INT AUTO_INCREMENT
- ApoliceID (FK) - INT NOT NULL (referência a `Apolice`)
- DataOcorrencia - DATE NOT NULL
- DataParticipacao - DATE NOT NULL
- Descricao - VARCHAR(200) NOT NULL
- ValorReclamado - Dom_Moeda
- ValorIndenizacaoTotal - Dom_Moeda
- Observacoes - VARCHAR(200)
*/
CREATE TABLE Sinistro (
    SinistroID INT PRIMARY KEY IDENTITY(1,1),
    ApoliceID INT NOT NULL REFERENCES Apolice(ApoliceID),
    DataOcorrencia DATE NOT NULL,
    DataParticipacao DATE NOT NULL,
    Descricao VARCHAR(200) NOT NULL,
    ValorReclamado Dom_Moeda,
    ValorIndenizacaoTotal Dom_Moeda DEFAULT 0,
    Observacoes VARCHAR(200)
);

/*
HistoricoSinistro
Regista etapas e alterações no tratamento de um sinistro ao longo do tempo.
Campos:
- HistoricoSinistroID (PK) - INT AUTO_INCREMENT
- SinistroID (FK) - INT NOT NULL (referência a `Sinistro`)
- DataAlteracao - DATETIME NOT NULL (data/hora da alteração; default = data atual)
- Estado - VARCHAR(15) NOT NULL ('Aberto', 'Em Análise', 'Fechado')
- ValorIndemnizadoNestaFase - Dom_Moeda
- DescricaoAlteracao - VARCHAR(200) NOT NULL
*/
CREATE TABLE HistoricoSinistro (
    HistoricoSinistroID INT PRIMARY KEY IDENTITY(1,1),
    SinistroID INT NOT NULL REFERENCES Sinistro(SinistroID),
    DataAlteracao DATETIME NOT NULL DEFAULT GETDATE(),
    Estado VARCHAR(15) NOT NULL CHECK (Estado IN ('Aberto', 'Em Análise', 'Fechado')),
    ValorIndemnizadoNestaFase Dom_Moeda,
    DescricaoAlteracao VARCHAR(200) NOT NULL
);
GO
