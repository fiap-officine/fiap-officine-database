-- ─────────────────────────────────────────────────────────────
-- 02_seed_data.sql
-- Carga Inicial de Dados de Teste (Clientes e Ordens de Serviço)
-- ─────────────────────────────────────────────────────────────

-- 1. Inserir Clientes de Teste para Validação da Lambda de Autenticação
INSERT INTO clientes (id, cpf, nome, email, telefone, status)
VALUES
    ('a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', '52998224725', 'Carlos Silva', 'carlos.silva@email.com', '11999990001', 'ATIVO'),
    ('b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e', '45892348083', 'Mariana Oliveira', 'mariana.oliveira@email.com', '11999990002', 'ATIVO'),
    ('c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f', '12345678909', 'Roberto Inativo', 'roberto.inativo@email.com', '11999990003', 'INATIVO')
ON CONFLICT (cpf) DO NOTHING;

-- 2. Inserir Ordens de Serviço nos 3 Status Obrigatórios para Dashboards
INSERT INTO ordens_servico (
    codigo, cliente_id, placa_veiculo, modelo_veiculo, descricao, status,
    valor_total, data_inicio_diagnostico, data_inicio_execucao, data_finalizacao
)
VALUES
    -- Status: Diagnóstico
    (
        'OS-2026-001',
        'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
        'ABC1D23',
        'Honda Civic 2022',
        'Barulho intermitente na suspensão dianteira',
        'Diagnostico',
        350.00,
        CURRENT_TIMESTAMP - INTERVAL '2 hours',
        NULL,
        NULL
    ),
    -- Status: Execução
    (
        'OS-2026-002',
        'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e',
        'XYZ9K88',
        'Toyota Corolla 2021',
        'Troca de pastilhas de freio e óleo do motor',
        'Execucao',
        850.00,
        CURRENT_TIMESTAMP - INTERVAL '5 hours',
        CURRENT_TIMESTAMP - INTERVAL '3 hours',
        NULL
    ),
    -- Status: Finalização
    (
        'OS-2026-003',
        'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
        'ABC1D23',
        'Honda Civic 2022',
        'Alinhamento e balanceamento completo',
        'Finalizacao',
        220.00,
        CURRENT_TIMESTAMP - INTERVAL '1 day',
        CURRENT_TIMESTAMP - INTERVAL '20 hours',
        CURRENT_TIMESTAMP - INTERVAL '2 hours'
    )
ON CONFLICT (codigo) DO NOTHING;
