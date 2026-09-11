-- ─────────────────────────────────────────────────────────────
-- 01_create_tables.sql
-- DDL para o Banco de Dados fiap-officine (PostgreSQL)
-- ─────────────────────────────────────────────────────────────

-- Habilitar extensão para geração de UUID
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ─────────────────────────────────────────────────────────────
-- Tabela: clientes
-- Utilizada pela Function Serverless (Lambda) para autenticação por CPF
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS clientes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cpf VARCHAR(11) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    telefone VARCHAR(20),
    status VARCHAR(20) NOT NULL DEFAULT 'ATIVO',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_clientes_cpf UNIQUE (cpf),
    CONSTRAINT chk_clientes_status CHECK (status IN ('ATIVO', 'INATIVO', 'BLOQUEADO'))
);

-- Índices para otimização de busca rápida por CPF na Lambda de Autenticação
CREATE INDEX IF NOT EXISTS idx_clientes_cpf ON clientes (cpf);
CREATE INDEX IF NOT EXISTS idx_clientes_status ON clientes (status);

-- ─────────────────────────────────────────────────────────────
-- Tabela: ordens_servico
-- Utilizada pela Aplicação Principal e monitorada pela Observabilidade
-- (Status obrigatórios: Diagnostico, Execucao, Finalizacao)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ordens_servico (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(50) NOT NULL,
    cliente_id UUID NOT NULL,
    placa_veiculo VARCHAR(10) NOT NULL,
    modelo_veiculo VARCHAR(100),
    descricao TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'Diagnostico',
    valor_total NUMERIC(10, 2) DEFAULT 0.00,
    data_inicio_diagnostico TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    data_inicio_execucao TIMESTAMP WITH TIME ZONE,
    data_finalizacao TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_ordens_codigo UNIQUE (codigo),
    CONSTRAINT fk_ordens_cliente FOREIGN KEY (cliente_id) REFERENCES clientes (id) ON DELETE RESTRICT,
    CONSTRAINT chk_ordens_status CHECK (status IN ('Diagnostico', 'Execucao', 'Finalizacao', 'Cancelada'))
);

-- Índices para métricas de observabilidade e funil de O.S.
CREATE INDEX IF NOT EXISTS idx_ordens_cliente ON ordens_servico (cliente_id);
CREATE INDEX IF NOT EXISTS idx_ordens_status ON ordens_servico (status);
CREATE INDEX IF NOT EXISTS idx_ordens_created_at ON ordens_servico (created_at);
