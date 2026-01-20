/*
Contratos e respetivos pagamentos

Este relatório permite analisar a existência de contratos sem registo de pagamentos. A
consulta deverá:
	- listar todos os contratos;
	- indicar o número de pagamentos registados por contrato;
	- incluir contratos que ainda não tenham qualquer pagamento associado.

	Usar o inner join nos casos em que a relação é obrigatória e left join quando a relação é opcional.
	Nesse caso, os contratos sem pagamentos deverão aparecer com o número de pagamentos a 0.
	Fazer os joins necessários para obter os nomes da seguradora, do plano do produto, do mediador e do tomador.
*/
/*
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
*/

/*
Seguradoras e valor total de prémios pagos

Este relatório pretende analisar o volume financeiro associado a cada seguradora. A con-
sulta deverá:
- relacionar seguradoras, contratos e pagamentos;
- calcular o valor total de prémios pagos por seguradora;
- incluir seguradoras sem valores pagos;
- apresentar apenas seguradoras cujo valor total ultrapasse um limite definido pelo
aluno.

Usar o left join para garantir que todas as seguradoras aparecem, mesmo que não tenham
contratos ou pagamentos associados.

ISNULL foi usado para tratar casos onde não há pagamentos, garantindo que o valor total seja 0 nesses casos.
ISNULL(valor a ser substituído, valor de substituição) é uma função que substitui valores nulos por um valor especificado.

HAVING usado para filtrar resultados agregados, neste caso, para mostrar apenas seguradoras com valor total de prémios pagos acima de um certo limite.
*/
/*
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
*/


