USE [GestaoDeSeguros]
GO 

-- Inserir entidades de pessoas
INSERT INTO EntidadePessoa (Nome, NIF, TipoEntidade, DataNascimento, Morada, Localidade, Telefone, Email, Status)
VALUES
('Entidade Fisica A', '100000001', 'Pessoa Física', '1985-01-01', 'Rua A', 'Lisboa', '910000001', 'a@fisica.com', 'Ativo'),
('Entidade Fisica B', '100000002', 'Pessoa Física', '1992-02-02', 'Rua B', 'Porto', '910000002', 'b@fisica.com', 'Ativo'),
('Entidade Fisica C', '100000003', 'Pessoa Física', '1978-03-03', 'Rua C', 'Braga', '910000003', 'c@fisica.com', 'Ativo'),
('Entidade Fisica D', '100000004', 'Pessoa Física', '2000-04-04', 'Rua D', 'Coimbra', '910000004', 'd@fisica.com', 'Ativo'),
('Entidade Juridica A', '500000001', 'Pessoa Jurídica', '2010-01-01', 'Av A', 'Lisboa', '210000001', 'a@empresa.com', 'Ativo'),
('Entidade Juridica B', '500000002', 'Pessoa Jurídica', '2015-02-02', 'Av B', 'Porto', '210000002', 'b@empresa.com', 'Ativo'),
('Entidade Juridica C', '500000003', 'Pessoa Jurídica', '2018-03-03', 'Av C', 'Faro', '210000003', 'c@empresa.com', 'Ativo'),
('Entidade Juridica D', '500000004', 'Pessoa Jurídica', '2020-04-04', 'Av D', 'Evora', '210000004', 'd@empresa.com', 'Ativo');

-- Inserir entidades de bens
INSERT INTO EntidadeBem (ProprietárioID, DescricaoBem, IdentificacaoBem, ValorEstimado, DataAquisicao)
VALUES
(1, 'Carro Mercedes', 'AB-11-CD', 45000.00, '2024-05-10'),
(5, 'Armazém Logístico', 'MAT-9988', 500000.00, '2020-01-01'),
(2, 'Apartamento T2', 'PRED-4455', 200000.00, '2022-11-15'),
(6, 'Frota Camiões', 'TRUCK-01', 120000.00, '2023-08-20');

-- Inserir seguradoras
INSERT INTO Seguradora (Nome, NIF, Morada, Localidade, Email, Telefone, Status)
VALUES
('Seguradora A', '501000001', 'Torre A', 'Lisboa', 's_a@seg.pt', '211111111', 'Ativa'),
('Seguradora B', '501000002', 'Torre B', 'Porto', 's_b@seg.pt', '212222222', 'Ativa'),
('Seguradora C', '501000003', 'Torre C', 'Lisboa', 's_c@seg.pt', '213333333', 'Ativa'),
('Seguradora D', '501000004', 'Torre D', 'Porto', 's_d@seg.pt', '214444444', 'Ativa');

-- Inserir mediadores
INSERT INTO Mediador (Nome, NIF, Morada, Localidade, Email, Telefone, Status)
VALUES
('Mediador A', '201000001', 'Loja A', 'Lisboa', 'm_a@med.pt', '219999991', 'Ativo'),
('Mediador B', '201000002', 'Loja B', 'Porto', 'm_b@med.pt', '219999992', 'Ativo'),
('Mediador C', '201000003', 'Loja C', 'Lisboa', 'm_c@med.pt', '219999993', 'Ativo'),
('Mediador D', '201000004', 'Loja D', 'Porto', 'm_d@med.pt', '219999994', 'Ativo');

-- Inserir tipos de seguro
INSERT INTO TipoDeSeguro (Descricao) VALUES ('Auto'), ('Vida'), ('Multiriscos'), ('Saúde');

-- Inserir produtos
INSERT INTO Produto (SeguradoraID, TipoSeguroID, NomeProduto, Status)
VALUES (1, 1, 'Auto Total', 'Ativo'), (2, 3, 'Casa Segura', 'Ativo');

-- Inserir planos de produtos
INSERT INTO ProdutoPlano (ProdutoID, NomePlano, DataInicioVigencia)
VALUES (1, 'Plano Auto Gold', '2024-01-01'), (2, 'Plano Habitação Plus', '2024-01-01');

-- Inserir apólices
INSERT INTO Apolice (ProdutoPlanoID, MediadorID, DataEmissao, DataInicioVigencia, DataFimVigencia)
VALUES
(1, 1, '2025-01-01', '2025-01-01', '2026-01-01'), -- Ap 1
(1, 2, '2025-02-01', '2025-02-01', '2026-02-01'), -- Ap 2
(2, 3, '2025-03-01', '2025-03-01', '2026-03-01'), -- Ap 3
(2, 4, '2025-04-01', '2025-04-01', '2026-04-01'), -- Ap 4
(1, 1, '2025-05-01', '2025-05-01', '2026-05-01'), -- Ap 5
(2, 2, '2025-06-01', '2025-06-01', '2026-06-01'), -- Ap 6
(1, 3, '2025-07-01', '2025-07-01', '2026-07-01'), -- Ap 7
(2, 4, '2025-08-01', '2025-08-01', '2026-08-01'), -- Ap 8
(1, 1, '2025-09-01', '2025-09-01', '2026-09-01'), -- Ap 9
(2, 2, '2025-10-01', '2025-10-01', '2026-10-01'); -- Ap 10

-- Associar apólices a entidades de pessoas (Tomadores)
INSERT INTO ApoliceEntidadePessoa (ApoliceID, EntidadePessoaID, Papel)
VALUES
(1, 1, 'Tomador'), (2, 2, 'Tomador'), (3, 5, 'Tomador'), (4, 6, 'Tomador'),
(5, 3, 'Tomador'), (6, 7, 'Tomador'), (7, 4, 'Tomador'), (8, 8, 'Tomador'),
(9, 1, 'Tomador'), (10, 5, 'Tomador');

-- Associar apólices a entidades de bens (Segurados)
INSERT INTO Premio (ApoliceID, ValorContratado, Periodicidade, DataVencimento)
VALUES
(1, 500.00, 'Anual', '2025-01-15'), (2, 450.00, 'Anual', '2025-02-15'),
(3, 1200.00, 'Anual', '2025-03-15'), (4, 1500.00, 'Anual', '2025-04-15'),
(5, 300.00, 'Anual', '2025-05-15'), (6, 800.00, 'Anual', '2025-06-15'),
(7, 400.00, 'Anual', '2025-07-15'), (8, 950.00, 'Anual', '2025-08-15'),
(9, 500.00, 'Anual', '2025-09-15'), (10, 1100.00, 'Anual', '2025-10-15');

-- Inserir pagamentos de prémios
INSERT INTO Pagamento (PremioID, DataPagamento, ValorPago, MetodoPagamento)
VALUES
(1, '2025-01-10', 500.00, 'Multibanco'),
(2, '2025-02-10', 450.00, 'Multibanco'),
(3, '2025-03-10', 1200.00, 'Débito Direto'),
(5, '2025-05-10', 300.00, 'Dinheiro'),
(7, '2025-07-10', 400.00, 'Cartão de Crédito'),
(9, '2025-09-10', 500.00, 'Multibanco');
GO
