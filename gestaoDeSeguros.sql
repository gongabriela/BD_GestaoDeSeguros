-- Uso do banco de dados master para criar o novo banco de dados
USE [master]
GO

-- Verifica se o banco de dados já existe e o cria se não existir
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'GestaoDeSeguros')
BEGIN
    CREATE DATABASE [GestaoDeSeguros]
END
GO

-- Seleciona o banco de dados GestaoDeSeguros para uso
USE [GestaoDeSeguros]
GO

-- Limpeza de tabelas existentes para evitar conflitos
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
GO

-- Remoção de regras e tipos de dados personalizados existentes

-- Desvincylar e apagar a regra e o tipo de dado personalizado, se existirem
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

-- Regras e tipos de dados personalizados

-- Regra para valores monetários positivos
CREATE RULE RL_ValoresMonetarios AS @val >= 0;
GO

-- Tipo de dado personalizado para moeda
CREATE TYPE Dom_Moeda FROM DECIMAL(10,2) NOT NULL;
GO

-- Associação da regra ao tipo de dado personalizado
EXEC sp_bindrule 'RL_ValoresMonetarios', 'Dom_Moeda';
GO


/*
EntidadePessoa
- EntidadePessoaID (PK) - SMALLINT AUTO_INCREMENT
- Nome - VARCHAR(100) NOT NULL
- NIF - CHAR(9) NOT NULL UNIQUE
- TipoEntidade - eNum('Pessoa Física', 'Pessoa Jurídica') NOT NULL
- DataNascimento - DATE NOT NULL
- Morada - VARCHAR(200) NOT NULL
- Localidade - VARCHAR(100) NOT NULL
- Telefone - CHAR(15) NOT NULL
- Email - VARCHAR(100) NOT NULL
- Status - eNum('Ativo', 'Inativo') NOT NULL
- Observações - VARCHAR(200)
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
- EntidadeBemID (PK) - INT AUTO_INCREMENT
- EntidadeID (FK) - SMALLINT NOT NULL (Proprietário do bem)
- DescricaoBem - VARCHAR(200) NOT NULL
- IdentificacaoBem - VARCHAR(100) NOT NULL UNIQUE
- ValorEstimado - DECIMAL(10,2) NOT NULL
- DataAquisicao - DATE NOT NULL
- Observações - VARCHAR(200)
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
- Seguradora
 - SeguradoraID (PK) - SMALLINT AUTO_INCREMENT
 - Nome - VARCHAR(100) NOT NULL
 - NIF - CHAR(9) NOT NULL UNIQUE
 - Morada - VARCHAR(200) NOT NULL
 - Localidade - VARCHAR(100) NOT NULL
 - Email - VARCHAR(100) NOT NULL
 - Telefone - CHAR(15) NOT NULL
 - Status - eNum('Ativa', 'Inativa') NOT NULL
 - Observações - VARCHAR(200)
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
- Mediador
 - MediadorID (PK) - SMALLINT AUTO_INCREMENT
 - Nome - VARCHAR(100) NOT NULL
 - NIF - CHAR(9) NOT NULL UNIQUE
 - Morada - VARCHAR(200) NOT NULL
 - Localidade - VARCHAR(100) NOT NULL
 - Email - VARCHAR(100) NOT NULL
 - Telefone - CHAR(15) NOT NULL
 - Status - eNum('Ativo', 'Inativo') NOT NULL
 - Observações - VARCHAR(200)
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
 MediadorSeguradora
 - MediadorID (PK)(FK) - SMALLINT NOT NULL
 - SeguradoraID (PK)(FK) - SMALLINT NOT NULL
 - DataInicio - DATE NOT NULL
 - DataFim - DATE
 - Status - eNum('Ativo', 'Inativo') NOT NULL
 - Observações - VARCHAR(200)
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
 - TipoSeguroID (PK) - SMALLINT AUTO_INCREMENT
 - Descrição - VARCHAR(100) NOT NULL
 - Observações - VARCHAR(200)
*/
CREATE TABLE TipoDeSeguro (
    TipoSeguroID SMALLINT PRIMARY KEY IDENTITY(1,1),
    Descricao VARCHAR(100) NOT NULL,
    Observacoes VARCHAR(200)
);

/*
- Produto
 - ProdutoID (PK) - SMALLINT AUTO_INCREMENT
 - SeguradoraID (FK) - SMALLINT NOT NULL
 - TipoSeguroID (FK) - SMALLINT NOT NULL
 - NomeProduto - VARCHAR(100) NOT NULL
 - Status - eNum('Ativo', 'Descontinuado') NOT NULL
 - Observações - VARCHAR(200)
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
- ProdutoPlanoID (PK) - INT AUTO_INCREMENT
- ProdutoID (FK) - SMALLINT NOT NULL
- NomePlano - VARCHAR(100) NOT NULL
- DataInicioVigencia - DATE NOT NULL
- DataFimVigencia - DATE
- Observações - VARCHAR(200)
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
- CoberturaPlanoID (PK) - INT AUTO_INCREMENT
- ProdutoPlanoID (FK) - INT NOT NULL
- DescricaoCobertura - VARCHAR(200) NOT NULL
- LimiteCobertura - DECIMAL(10,2) NOT NULL
- Franquia - DECIMAL(10,2) NOT NULL
- Observações - VARCHAR(200)
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
Apólice
- ApoliceID (PK) - INT AUTO_INCREMENT
- ProdutoPlanoID (FK) - INT NOT NULL
- MediadorID (FK) - SMALLINT NOT NULL
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
- ApoliceEntidadeID (PK) - INT AUTO_INCREMENT
- ApoliceID (FK) - INT NOT NULL
- EntidadePessoaID (FK) - SMALLINT NOT NULL
- Papel - eNum('Tomador', 'Segurado', 'Beneficiário') NOT NULL
*/
CREATE TABLE ApoliceEntidadePessoa (
    ApoliceEntidadeID INT PRIMARY KEY IDENTITY(1,1),
    ApoliceID INT NOT NULL REFERENCES Apolice(ApoliceID),
    EntidadePessoaID SMALLINT NOT NULL REFERENCES EntidadePessoa(EntidadePessoaID),
    Papel VARCHAR(15) NOT NULL CHECK (Papel IN ('Tomador', 'Segurado', 'Beneficiário'))
);

/*
ApoliceEntidadeBem
- ApoliceEntidadeBemID (PK) - INT AUTO_INCREMENT
- ApoliceID (FK) - INT NOT NULL
- EntidadeBemID (FK) - INT NOT NULL
*/
CREATE TABLE ApoliceEntidadeBem (
    ApoliceEntidadeBemID INT PRIMARY KEY IDENTITY(1,1),
    ApoliceID INT NOT NULL REFERENCES Apolice(ApoliceID),
    EntidadeBemID INT NOT NULL REFERENCES EntidadeBem(EntidadeBemID)
);

/*
HistóricoApolice
- HistoricoApoliceID (PK) - INT AUTO_INCREMENT
- ApoliceID (FK) - INT NOT NULL
- DataAlteracao - DATETIME NOT NULL
- EstadoAnterior - eNum('Ativa', 'Suspensa', 'Cancelada', 'Expirada') NOT NULL
- EstadoNovo - eNum('Ativa', 'Suspensa', 'Cancelada', 'Expirada') NOT NULL
- DescricaoAlteracao - VARCHAR(200) NOT NULL
*/
CREATE TABLE HistoricoApolice (
    HistoricoApoliceID INT PRIMARY KEY IDENTITY(1,1),
    ApoliceID INT NOT NULL REFERENCES Apolice(ApoliceID),
    DataAlteracao DATETIME NOT NULL DEFAULT GETDATE(),
    EstadoAnterior VARCHAR(15) NOT NULL CHECK (EstadoAnterior IN ('Ativa', 'Suspensa', 'Cancelada', 'Expirada')),
    EstadoNovo VARCHAR(15) NOT NULL CHECK (EstadoNovo IN ('Ativa', 'Suspensa', 'Cancelada', 'Expirada')),
    DescricaoAlteracao VARCHAR(200) NOT NULL
);

/*
Premio
- PremioID (PK) - INT AUTO_INCREMENT
- ApoliceID (FK) - INT NOT NULL UNI
- ValorContratado - DECIMAL(10,2) NOT NULL
- Periodicidade - eNum('Mensal', 'Trimestral', 'Semestral', 'Anual') NOT NULL
- DataVencimento - DATE NOT NULL
- Observações - VARCHAR(200)
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
- PagamentoID (PK) - INT AUTO_INCREMENT
- PremioID (FK) - INT NOT NULL
- DataPagamento - DATE NOT NULL
- ValorPago - DECIMAL(10,2) NOT NULL
- MetodoPagamento - eNum('Multibanco', 'Cartão de Crédito', 'Débito Direto', 'Dinheiro')
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
- SinistroID (PK) - INT AUTO_INCREMENT
- ApoliceID (FK) - INT NOT NULL
- DataOcorrencia - DATE NOT NULL
- DataParticipacao - DATE NOT NULL
- Descricao - VARCHAR(200) NOT NULL
- ValorReclamado - DECIMAL(10,2) NOT NULL
- ValorIndenizacaoTotal - DECIMAL(10,2)
- Status - eNum('Aberto', 'Em Análise', 'Fechado', 'Indenizado') NOT NULL
- Observações - VARCHAR(200)
*/
CREATE TABLE Sinistro (
    SinistroID INT PRIMARY KEY IDENTITY(1,1),
    ApoliceID INT NOT NULL REFERENCES Apolice(ApoliceID),
    DataOcorrencia DATE NOT NULL,
    DataParticipacao DATE NOT NULL,
    Descricao VARCHAR(200) NOT NULL,
    ValorReclamado Dom_Moeda,
    ValorIndenizacaoTotal Dom_Moeda DEFAULT 0,
    Status VARCHAR(15) NOT NULL CHECK (Status IN ('Aberto', 'Em Análise', 'Fechado', 'Indenizado')),
    Observacoes VARCHAR(200)
);

/*
HistoricoSinistro
- HistoricoSinistroID (PK) - INT AUTO_INCREMENT
- SinistroID (FK) - INT NOT NULL
- DataAlteracao - DATETIME NOT NULL
- EstadoAnterior - eNum('Aberto', 'Em Análise', 'Fechado') NOT NULL
- EstadoNovo - eNum('Aberto', 'Em Análise', 'Fechado') NOT NULL
- ValorIndemnizadoNestaFase - DECIMAL(10,2)
- DescricaoAlteracao - VARCHAR(200) NOT NULL
*/
CREATE TABLE HistoricoSinistro (
    HistoricoSinistroID INT PRIMARY KEY IDENTITY(1,1),
    SinistroID INT NOT NULL REFERENCES Sinistro(SinistroID),
    DataAlteracao DATETIME NOT NULL DEFAULT GETDATE(),
    EstadoAnterior VARCHAR(15) NOT NULL CHECK (EstadoAnterior IN ('Aberto', 'Em Análise', 'Fechado')),
    EstadoNovo VARCHAR(15) NOT NULL CHECK (EstadoNovo IN ('Aberto', 'Em Análise', 'Fechado')),
    ValorIndemnizadoNestaFase Dom_Moeda,
    DescricaoAlteracao VARCHAR(200) NOT NULL
);
GO
