USE [GestaoDeSeguros]
GO

-- CONTRATOS POR TIPO DE SEGURO
-- Lista todos os tipos e número de contratos por tipo.
-- Inclui tipos que não possuem contratos registados.
-- Útil para identificar os tipos mais e menos representativos.
GO
CREATE VIEW vw_ContratosPorTipoDeSeguro
AS
    SELECT t.Descricao AS TipoDeSeguro, COUNT(a.ApoliceID) AS Contratos
    FROM TipoDeSeguro t
        LEFT JOIN Produto p ON p.TipoSeguroID = t.TipoSeguroID
        LEFT JOIN ProdutoPlano pp ON pp.ProdutoID = p.ProdutoID
        LEFT JOIN Apolice a ON a.ProdutoPlanoID = pp.ProdutoPlanoID
    GROUP BY t.TipoSeguroID, t.Descricao
GO

-- SEGURADORAS E NÚMERO DE CONTRATOS ATIVOS
-- Lista todas as seguradoras com o número de contratos ativos associado a cada uma.
-- Inclui seguradoras que não têm contratos ativos registados.
GO
CREATE VIEW vw_SeguradorasENumeroDeContratosAtivos
AS
    SELECT s.Nome AS Seguradora, COUNT(a.ApoliceID) AS NumeroContratosAtivos
    FROM Seguradora s
        LEFT JOIN Produto p ON s.SeguradoraID = p.SeguradoraID
        LEFT JOIN ProdutoPlano pp ON p.ProdutoID = pp.ProdutoID
        LEFT JOIN Apolice a ON pp.ProdutoPlanoID = a.ProdutoPlanoID
    AND GETDATE() BETWEEN a.DataInicioVigencia AND a.DataFimVigencia
    GROUP BY s.SeguradoraID, s.Nome
GO

-- VALOR MÉDIO DO PRÊMIO POR TIPO DE SEGURO
-- Calcula o valor médio do prémio por tipo de seguro.
-- Considera apenas prémios de apólices cuja vigência cobre a data atual.
GO
CREATE VIEW vw_ValorMedioDoPremioPorTipoDeSeguro
AS
    SELECT ts.Descricao AS TipoDeSeguro, CAST(AVG(pr.ValorContratado) AS DECIMAL(10,2)) AS ValorMedioPremio
    FROM TipoDeSeguro ts
        INNER JOIN Produto p ON ts.TipoSeguroID = p.TipoSeguroID
        INNER JOIN ProdutoPlano pp ON p.ProdutoID = pp.ProdutoID
        INNER JOIN Apolice a ON pp.ProdutoPlanoID = a.ProdutoPlanoID
        INNER JOIN Premio pr ON a.ApoliceID = pr.ApoliceID
    WHERE GETDATE() BETWEEN a.DataInicioVigencia AND a.DataFimVigencia
    GROUP BY ts.TipoSeguroID, ts.Descricao
GO

-- CLIENTES E NÚMERO DE CONTRATOS CELEBRADOS
-- Lista clientes com o número de contratos associados a cada cliente.
-- Identifica clientes que têm mais de um contrato.
-- Inclui clientes sem contratos registados no sistema.
GO
CREATE VIEW vw_ClientesENumeroDeContratosCelebrados
AS
    SELECT ep.Nome AS Cliente, COUNT(aep.ApoliceID) AS NumeroDeContratos,
        CASE
            WHEN COUNT(aep.ApoliceID) > 1 THEN 'Sim'
            ELSE 'Não'
        END AS MaisDeUmContrato
    FROM EntidadePessoa ep
    LEFT JOIN ApoliceEntidadePessoa aep ON ep.EntidadePessoaID = aep.EntidadePessoaID AND aep.Papel IN ('Tomador', 'Segurado')
    GROUP BY ep.EntidadePessoaID, ep.Nome
GO

-- CONTRATOS E RESPECTIVOS PAGAMENTOS
-- Lista apólices com o número de pagamentos registados por contrato.
-- Inclui apólices que ainda não têm pagamentos associados.
GO
CREATE VIEW vw_RelatorioPagamentosPorContrato
AS
    SELECT
        a.ApoliceID,
        s.Nome AS Seguradora,
        pp.NomePlano,
        m.Nome AS Mediador,
        ep.Nome AS Tomador,
        COUNT(p.PagamentoID) AS NumeroPagamentos
    FROM Apolice a
        INNER JOIN ProdutoPlano pp ON a.ProdutoPlanoID = pp.ProdutoPlanoID
        INNER JOIN Produto pr ON pp.ProdutoID = pr.ProdutoID
        INNER JOIN Seguradora s ON pr.SeguradoraID = s.SeguradoraID
        INNER JOIN Mediador m ON a.MediadorID = m.MediadorID
        INNER JOIN ApoliceEntidadePessoa aep ON a.ApoliceID = aep.ApoliceID AND aep.Papel = 'Tomador'
        INNER JOIN EntidadePessoa ep ON aep.EntidadePessoaID = ep.EntidadePessoaID
        LEFT JOIN Premio pm ON a.ApoliceID = pm.ApoliceID
        LEFT JOIN Pagamento p ON pm.PremioID = p.PremioID
    GROUP BY a.ApoliceID, s.Nome, pp.NomePlano, m.Nome, ep.Nome;
GO

-- SEGURADORAS E VALOR TOTAL DE PRÊMIOS PAGOS
-- Calcula o valor total de prémios pagos por seguradora.
-- Inclui seguradoras sem pagamentos (resultado 0).
-- O filtro `HAVING` limita seguradoras por valor mínimo acumulado (ex.: >= 1000).
GO
CREATE VIEW vw_RelatorioValorTotalPremiosPorSeguradora
AS
SELECT
	s.Nome AS Seguradora,
	ISNULL(SUM(p.ValorPago), 0) AS ValorTotalPremiosPagos
FROM Seguradora s
	LEFT JOIN Produto pr ON s.SeguradoraID = pr.SeguradoraID
	LEFT JOIN ProdutoPlano pp ON pr.ProdutoID = pp.ProdutoID
	LEFT JOIN Apolice a ON pp.ProdutoPlanoID = a.ProdutoPlanoID
	LEFT JOIN Premio pm ON a.ApoliceID = pm.ApoliceID
	LEFT JOIN Pagamento p ON pm.PremioID = p.PremioID
GROUP BY s.Nome
HAVING ISNULL(SUM(p.ValorPago), 0) >= 1000;
GO

-- CONTRATOS E EXISTÊNCIA DE SINISTROS
-- Lista apólices e o número de sinistros associados a cada uma.
-- Identifica as 10 apólices com maior número de sinistros.
-- Inclui apólices que não têm sinistros registados.
GO
CREATE VIEW vw_ContratosEExistenciaDeSinistros
AS
    SELECT TOP 10 a.ApoliceID, COUNT(s.SinistroID) AS NumeroDeSinistros
    FROM Apolice a
        LEFT JOIN Sinistro s ON a.ApoliceID = s.ApoliceID
    GROUP BY a.ApoliceID
    ORDER BY NumeroDeSinistros DESC;
GO

-- RELATÓRIO DO ALUNO: HISTÓRICO DE APÓLICES
-- Visão genérica do histórico de alterações das apólices.
-- Inclui seguradora, tipo de seguro, plano, data e descrição da alteração.
GO
CREATE VIEW vw_HistoricoApolice
AS
    SELECT
        a.ApoliceID,
        s.Nome AS Seguradora,
        ts.Descricao AS TipoDeSeguro,
        pp.NomePlano,
        CAST(ha.DataAlteracao AS DATE) AS DataAlteracao,
        ha.Estado,
        ha.DescricaoAlteracao
    FROM HistoricoApolice ha
    INNER JOIN Apolice a ON ha.ApoliceID = a.ApoliceID
    INNER JOIN ProdutoPlano pp ON a.ProdutoPlanoID = pp.ProdutoPlanoID
    INNER JOIN Produto p ON pp.ProdutoID = p.ProdutoID
    INNER JOIN Seguradora s ON p.SeguradoraID = s.SeguradoraID
    INNER JOIN TipoDeSeguro ts ON p.TipoSeguroID = ts.TipoSeguroID;
GO

