USE [GestaoDeSeguros]
GO 

-- CONTRATOS POR TIPO DE SEGURO
-- listar todos os tipos de seguro existentes;
-- apresentar o número de contratos associados a cada tipo;
-- incluir tambem os tipos de seguro que nao possuem contratos associados
-- permitir identificar tipos de seguro mais e menos representativos (ordenação)

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

-- SEGURADORAS E NUMERO DE CONTRATOS ATIVOS
-- listar todas as seguradoras
-- apresentar o numero de contratos ativos associados a cada seguradora
-- incluir seguradoras sem contratos ativos
-- ordenar os resultados por numero de contratos de forma decrescente

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

-- VALOR MEDIO DO PREMIO POR TIPO DE SEGURO
-- relacionar contratos e tipos de seguro
-- calcular o valor medio do premio por tipo de seguro
-- considerar apenas contratos ativos

GO
CREATE VIEW vw_ValorMedioDoPremioPorTipoDeSeguro
AS
    SELECT ts.Descricao AS TipoDeSeguro, AVG(pr.ValorContratado) AS ValorMedioPremio
    FROM TipoDeSeguro ts
        INNER JOIN Produto p ON ts.TipoSeguroID = p.TipoSeguroID
        INNER JOIN ProdutoPlano pp ON p.ProdutoID = pp.ProdutoID
        INNER JOIN Apolice a ON pp.ProdutoPlanoID = a.ProdutoPlanoID
        INNER JOIN Premio pr ON a.ApoliceID = pr.ApoliceID
    WHERE GETDATE() BETWEEN a.DataInicioVigencia AND a.DataFimVigencia 
    GROUP BY ts.TipoSeguroID, ts.Descricao
GO

-- CLIENTES E NUMERO DE CONTRATOS CELEBRADOS
-- listar todas as entidades que assumem o papel de cliente
-- apresentar o numero de contratos associados a cada cliente
-- incluir clientes sem contratos
-- identificar clientes com mais do que um contrato

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

-- CONTRATOS E RESPETIVOS PAGAMENTOS
-- listar todos os contratos
-- indicar o numero de pagamentos registados por contrato
-- incluir contratos que ainda nao tenham qualquer pagamento associado

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

-- SEGURADORAS E VALOR TOTAL DE PREMIOS PAGOS
-- relacionar seguradoras, contratos e pagamentos
-- calcular o valor total de premios pagos por seguradora
-- incluir seguradoras sem valores pagos
-- apresentar apenas seguradoras cujo valor total ultrapasse o limite definido pelo aluno

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
HAVING ISNULL(SUM(p.ValorPago), 0) >= 0;
GO

-- CONTRATOS E EXISTENCIA DE SINISTROS
-- listar todos os contratos
-- indicar o numero de sinistros associados a cada contrato
-- incluir contratos sem qualquer sinistro
-- permitir distinguir os 10 contratos com maior exposicao a risco

GO
CREATE VIEW vw_ContratosEExistenciaDeSinistros
AS
    SELECT TOP 10 a.ApoliceID, COUNT(s.SinistroID) AS NumeroDeSinistros
    FROM Apolice a
        LEFT JOIN Sinistro s ON a.ApoliceID = s.ApoliceID
    GROUP BY a.ApoliceID
    ORDER BY NumeroDeSinistros DESC;
GO

-- RELATORIO DO ALUNO: taxa de abandono e fidelizacao







