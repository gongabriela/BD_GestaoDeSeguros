-- CONTRATOS POR TIPO DE SEGURO
    SELECT * FROM vw_ContratosPorTipoDeSeguro
    ORDER BY Contratos desc

-- SEGURADORAS E NUMERO DE CONTRATOS ATIVOS
    SELECT * FROM vw_SeguradorasENumeroDeContratosAtivos
    ORDER BY NumeroContratosAtivos DESC;

-- VALOR MEDIO DO PREMIO POR TIPO DE SEGURO
    SELECT * FROM vw_ValorMedioDoPremioPorTipoDeSeguro
    ORDER BY ValorMedioPremio DESC;

-- CLIENTES E NUMERO DE CONTRATOS CELEBRADOS
    SELECT * FROM vw_ClientesENumeroDeContratosCelebrados
    ORDER BY NumeroDeContratos DESC;

-- CONTRATOS E RESPETIVOS PAGAMENTOS
    SELECT * FROM vw_RelatorioPagamentosPorContrato;

-- SEGURADORAS E VALOR TOTAL DE PREMIOS PAGOS
    SELECT * FROM vw_RelatorioValorTotalPremiosPorSeguradora;

-- CONTRATOS E EXISTENCIA DE SINISTROS
    SELECT * FROM vw_ContratosEExistenciaDeSinistros
    ORDER BY NumeroDeSinistros DESC;
