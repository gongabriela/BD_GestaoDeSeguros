-- CONTRATOS POR TIPO DE SEGURO
-- listar todos os tipos de seguro existentes;
-- apresentar o número de contratos associados a cada tipo;
-- incluir tambem os tipos de seguro que nao possuem contratos associados
-- permitir identificar tipos de seguro mais e menos representativos (ordenação)

    SELECT t.Descricao AS TipoDeSeguro, COUNT(a.ApoliceID) AS Contratos 
    FROM TipoDeSeguro t
        LEFT JOIN Produto p ON p.TipoSeguroID = t.TipoSeguroID
        LEFT JOIN ProdutoPlano pp ON pp.ProdutoID = p.ProdutoID
        LEFT JOIN Apolice a ON a.ProdutoPlanoID = pp.ProdutoPlanoID
    GROUP BY t.TipoSeguroID, t.Descricao
    ORDER BY Contratos desc

-- SEGURADORAS E NUMERO DE CONTRATOS ATIVOS
-- listar todas as seguradoras
-- apresentar o numero de contratos ativos associados a cada seguradora
-- incluir seguradoras sem contratos ativos
-- ordenar os resultados por numero de contratos de forma decrescente

    SELECT s.Nome AS Seguradora, COUNT(a.ApoliceID) AS NumeroContratosAtivos
    FROM Seguradora s
        LEFT JOIN Produto p ON s.SeguradoraID = p.SeguradoraID
        LEFT JOIN ProdutoPlano pp ON p.ProdutoID = pp.ProdutoID
        LEFT JOIN Apolice a ON pp.ProdutoPlanoID = a.ProdutoPlanoID
    AND GETDATE() BETWEEN a.DataInicioVigencia AND a.DataFimVigencia
    GROUP BY s.SeguradoraID, s.Nome
    ORDER BY NumeroContratosAtivos DESC;

-- VALOR MEDIO DO PREMIO POR TIPO DE SEGURO
-- relacionar contratos e tipos de seguro
-- calcular o valor medio do premio por tipo de seguro
-- considerar apenas contratos ativos

    SELECT ts.Descricao AS TipoDeSeguro, AVG(pr.ValorContratado) AS ValorMedioPremio
    FROM TipoDeSeguro ts
        INNER JOIN Produto p ON ts.TipoSeguroID = p.TipoSeguroID
        INNER JOIN ProdutoPlano pp ON p.ProdutoID = pp.ProdutoID
        INNER JOIN Apolice a ON pp.ProdutoPlanoID = a.ProdutoPlanoID
        INNER JOIN Premio pr ON a.ApoliceID = pr.ApoliceID
    WHERE GETDATE() BETWEEN a.DataInicioVigencia AND a.DataFimVigencia 
    GROUP BY ts.TipoSeguroID, ts.Descricao
    ORDER BY ValorMedioPremio DESC;

-- CLIENTES E NUMERO DE CONTRATOS CELEBRADOS
-- listar todas as entidades que assumem o papel de cliente
-- apresentar o numero de contratos associados a cada cliente
-- incluir clientes sem contratos
-- identificar clientes com mais do que um contrato

    SELECT ep.Nome AS Cliente, COUNT(aep.ApoliceID) AS NumeroDeContratos,
        CASE
            WHEN COUNT(aep.ApoliceID) > 1 THEN 'Sim'
            ELSE 'Não'
        END AS MaisDeUmContrato
    FROM EntidadePessoa ep
    LEFT JOIN ApoliceEntidadePessoa aep ON ep.EntidadePessoaID = aep.EntidadePessoaID AND aep.Papel IN ('Tomador', 'Segurado')
    GROUP BY ep.EntidadePessoaID, ep.Nome
    ORDER BY NumeroDeContratos DESC;

-- CONTRATOS E RESPETIVOS PAGAMENTOS
-- listar todos os contratos
-- indicar o numero de pagamentos registados por contrato
-- incluir contratos que ainda nao tenham qualquer pagamento associado



-- SEGURADORAS E VALOR TOTAL DE PREMIOS PAGOS
-- relacionar seguradoras, contratos e pagamentos
-- calcular o valor total de premios pagos por seguradora
-- incluir seguradoras sem valores pagos
-- apresentar apenas seguradoras cujo valor total ultrapasse o limite definido pelo aluno



-- CONTRATOS E EXISTENCIA DE SINISTROS
-- listar todos os contratos
-- indicar o numero de sinistros associados a cada contrato
-- incluir contratos sem qualquer sinistro
-- permitir distinguir os 10 contratos com maior exposicao a risco

    SELECT TOP 10 a.ApoliceID, COUNT(s.SinistroID) AS NumeroDeSinistros
    FROM Apolice a
        LEFT JOIN Sinistro s ON a.ApoliceID = s.ApoliceID
    GROUP BY a.ApoliceID
    ORDER BY NumeroDeSinistros DESC;

-- RELATORIO DO ALUNO: taxa de abandono e fidelizacao







