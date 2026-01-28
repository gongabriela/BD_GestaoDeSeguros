USE [GestaoDeSeguros]
GO
-- ENTIDADE PESSOA
-- Insere registos de pessoas físicas e jurídicas de exemplo.
INSERT INTO EntidadePessoa (Nome, NIF, TipoEntidade, DataNascimento, Morada, Localidade, Telefone, Email, Status)
VALUES
('Ana Silva', '100000001', 'Pessoa Física', '1985-05-20', 'Rua das Flores, 1', 'Lisboa', '910000001', 'ana@email.com', 'Ativo'),
('Bruno Costa', '100000002', 'Pessoa Física', '1992-10-10', 'Rua do Porto, 2', 'Porto', '910000002', 'bruno@email.com', 'Ativo'),
('Carlos Sousa', '100000003', 'Pessoa Física', '1978-03-15', 'Rua de Braga, 3', 'Braga', '910000003', 'carlos@email.com', 'Ativo'),
('Daniela Reis', '100000004', 'Pessoa Física', '2000-12-25', 'Rua de Coimbra, 4', 'Coimbra', '910000004', 'daniela@email.com', 'Ativo'),
('Tech Solutions Lda', '500000001', 'Pessoa Jurídica', '2010-01-01', 'Av. da Liberdade, 100', 'Lisboa', '210000001', 'geral@tech.com', 'Ativo'),
('Construções Norte SA', '500000002', 'Pessoa Jurídica', '2015-06-01', 'Zona Industrial, Lote 5', 'Porto', '220000002', 'norte@email.com', 'Ativo'),
('Padaria Central', '500000003', 'Pessoa Jurídica', '2018-03-20', 'Praça do Município, 10', 'Faro', '289000003', 'padaria@email.com', 'Ativo'),
('Consultoria X', '500000004', 'Pessoa Jurídica', '2020-09-15', 'Business Center, Sl 4', 'Lisboa', '210000004', 'x@email.com', 'Ativo');

-- ENTIDADE BEM
-- Insere bens pertencentes a entidades, com identificação e valor estimado.
INSERT INTO EntidadeBem (ProprietárioID, DescricaoBem, IdentificacaoBem, ValorEstimado, DataAquisicao)
VALUES
(1, 'Tesla Model 3', 'AA-11-BB', 45000.00, '2024-01-10'),
(5, 'Servidores Rack H1', 'SRV-9988', 50000.00, '2023-05-01'),
(2, 'Apartamento T3', 'MAT-4455-P', 250000.00, '2022-11-15'),
(6, 'Frota de Camiões', 'TRUCK-GROUP-1', 400000.00, '2023-08-20');

-- SEGURADORA
-- Registos de seguradoras utilizadas nos exemplos.
INSERT INTO Seguradora (Nome, NIF, Morada, Localidade, Email, Telefone, Status)
VALUES
('Seguradora A', '501000001', 'Torre A, Lisboa', 'Lisboa', 'geral@seg-a.pt', '211111111', 'Ativa'),
('Seguradora B', '501000002', 'Edifício B, Porto', 'Porto', 'geral@seg-b.pt', '221111111', 'Ativa'),
('Seguradora C', '501000003', 'Avenida C, Lisboa', 'Lisboa', 'geral@seg-c.pt', '213333333', 'Ativa'),
('Seguradora D', '501000004', 'Praça D, Porto', 'Porto', 'geral@seg-d.pt', '224444444', 'Ativa');

-- MEDIADOR
-- Registos de mediadores comerciais que intermediam apólices.
INSERT INTO Mediador (Nome, NIF, Morada, Localidade, Email, Telefone, Status)
VALUES
('Mediador Principal', '201000001', 'Rua do Comércio', 'Lisboa', 'vendas@med.pt', '219999991', 'Ativo'),
('Mediador Norte', '201000002', 'Rua Central', 'Porto', 'norte@med.pt', '229999992', 'Ativo');

-- MEDIADOR - SEGURADORA
-- Associação entre mediadores e seguradoras com períodos de validade.
INSERT INTO MediadorSeguradora (MediadorID, SeguradoraID, DataInicio, DataFim, Status)
VALUES
(1, 1, '2023-01-01', NULL, 'Ativo'),
(2, 1, '2020-01-01', '2023-12-31', 'Inativo'),
(2, 2, '2023-02-01', NULL, 'Ativo'),
(1, 3, '2023-03-01', NULL, 'Ativo');

-- TIPO DE SEGURO
-- Tipos de seguro base usados para classificar produtos.
INSERT INTO TipoDeSeguro (Descricao) VALUES ('Auto'), ('Vida'), ('Multiriscos'), ('Saúde');

-- PRODUTO
-- Produtos oferecidos pelas seguradoras para cada tipo de seguro.
INSERT INTO Produto (SeguradoraID, TipoSeguroID, NomeProduto, Status)
VALUES
(1, 1, 'Auto Global', 'Ativo'),
(2, 3, 'Casa Segura', 'Ativo'),
(3, 2, 'Vida Proteção', 'Ativo');


-- PRODUTO PLANO
-- Planos associados a produtos, com data de início de vigência.
INSERT INTO ProdutoPlano (ProdutoID, NomePlano, DataInicioVigencia)
VALUES
(1, 'Plano Auto Base', '2024-01-01'),
(1, 'Plano Auto VIP', '2024-01-01'),
(2, 'Plano Habitação Plus', '2024-01-01'),
(3, 'Plano Vida Familiar', '2024-01-01');


-- COBERTURA PLANO
-- Coberturas detalhadas aplicáveis a um plano, com limites e franquias.
INSERT INTO CoberturaPlano (ProdutoPlanoID, DescricaoCobertura, LimiteCobertura, Franquia)
VALUES
(1, 'Danos Próprios', 30000.00, 500.00),
(1, 'Responsabilidade Civil', 100000.00, 0.00),
(3, 'Incêndio', 200000.00, 1000.00),
(4, 'Morte Acidental', 50000.00, 0.00);


-- COBERTURA - PRODUTO PLANO
-- Associação entre planos e coberturas disponíveis para cada plano.
INSERT INTO CoberturaProdutoPlano (ProdutoPlanoID, CoberturaPlanoID)
VALUES (1, 1), (1, 2), (3, 3), (4, 4);


-- APÓLICE
-- Criação de apólices associadas a planos e mediadores.
INSERT INTO Apolice (ProdutoPlanoID, MediadorID, DataEmissao, DataInicioVigencia, DataFimVigencia)
VALUES
(1, 1, '2025-01-01', '2025-01-01', '2026-01-01'),
(2, 1, '2025-01-05', '2025-01-05', '2026-01-05'),
(3, 2, '2025-02-01', '2025-02-01', '2026-02-01'),
(4, 1, '2025-03-01', '2025-03-01', '2026-03-01'),
(1, 1, '2025-04-01', '2025-04-01', '2026-04-01'),
(2, 2, '2025-05-01', '2025-05-01', '2026-05-01'),
(3, 1, '2025-06-01', '2025-06-01', '2026-06-01'),
(1, 1, '2025-07-01', '2025-07-01', '2026-07-01'),
(2, 2, '2025-08-01', '2025-08-01', '2026-08-01'),
(1, 1, '2025-09-01', '2025-09-01', '2026-09-01');


-- APÓLICE - ENTIDADE PESSOA
-- Liga apólices a pessoas (tomador, segurado, beneficiário, etc.).
INSERT INTO ApoliceEntidadePessoa (ApoliceID, EntidadePessoaID, Papel)
VALUES
(1, 1, 'Tomador'), (2, 1, 'Tomador'), (7, 1, 'Tomador'),
(3, 2, 'Tomador'), (4, 3, 'Tomador'), (8, 4, 'Tomador'),
(5, 5, 'Tomador'), (10, 5, 'Tomador'), (6, 6, 'Tomador'), (9, 8, 'Tomador');


-- APÓLICE - ENTIDADE BEM
-- Associa bens às apólices, indicando quais bens estão cobertos.
INSERT INTO ApoliceEntidadeBem (ApoliceID, EntidadeBemID)
VALUES
(1, 1), (2, 1), (3, 3), (5, 2), (6, 4), (10, 2);


-- HISTÓRICO APÓLICE
-- Regista alterações de estado das apólices ao longo do tempo.
INSERT INTO HistoricoApolice (ApoliceID, DataAlteracao, Estado, DescricaoAlteracao)
VALUES
(1, '2025-01-10','Suspensa', 'Falta de pagamento'),
(1, '2025-01-12', 'Ativa', 'Pagamento regularizado'),
(2, '2025-02-15', 'Cancelada', 'Solicitação do cliente');


-- PRÉMIO
-- Valores contratados de prémio por apólice e periodicidade.
INSERT INTO Premio (ApoliceID, ValorContratado, Periodicidade, DataVencimento)
VALUES
(1, 400.00, 'Anual', '2025-01-15'), (2, 600.00, 'Anual', '2025-01-20'),
(3, 350.00, 'Anual', '2025-02-15'), (4, 120.00, 'Mensal', '2025-03-15'),
(5, 1200.00, 'Anual', '2025-04-15'), (6, 2500.00, 'Anual', '2025-05-15'),
(7, 300.00, 'Anual', '2025-06-15'), (8, 420.00, 'Anual', '2025-07-15'),
(9, 150.00, 'Mensal', '2025-08-15'), (10, 800.00, 'Anual', '2025-09-15');


-- PAGAMENTO
-- Registos de pagamentos realizados para prémios.
INSERT INTO Pagamento (PremioID, DataPagamento, ValorPago, MetodoPagamento)
VALUES
(1, '2025-01-10', 400.00, 'Multibanco'),
(2, '2025-01-15', 600.00, 'Multibanco'),
(3, '2025-02-10', 350.00, 'Débito Direto'),
(4, '2025-03-10', 120.00, 'Dinheiro'),
(5, '2025-04-10', 1200.00, 'Multibanco'),
(6, '2025-05-10', 2500.00, 'Multibanco'),
(7, '2025-06-10', 300.00, 'Cartão de Crédito');


-- SINISTRO
-- Registos de sinistros reportados por apólice.
INSERT INTO Sinistro (ApoliceID, DataOcorrencia, DataParticipacao, Descricao, ValorReclamado, ValorIndenizacaoTotal)
VALUES
(1, '2025-05-20', '2025-05-22', 'Pequena colisão', 500.00, 450.00),
(1, '2025-06-10', '2025-06-11', 'Quebra de vidro', 150.00, 150.00),
(5, '2025-08-15', '2025-08-20', 'Dano elétrico', 2000.00, 0.00);


-- HISTÓRICO SINISTRO
-- Histórico de estados e indemnizações por sinistro.
INSERT INTO HistoricoSinistro (SinistroID, DataAlteracao, Estado, ValorIndemnizadoNestaFase, DescricaoAlteracao)
VALUES
(1, '2025-05-22', 'Em Análise', 0.00, 'Início da peritagem'),
(1, '2025-05-28', 'Fechado', 450.00, 'Indemnização paga'),
(3, '2025-08-20', 'Em Análise', 0.00, 'Aguardar orçamentos');
GO

