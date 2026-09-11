# fiap-officine-database

Repositório de infraestrutura e gerenciamento do banco de dados relacional (**AWS RDS PostgreSQL**) do projeto **fiap-officine**.

---

## 🏛️ Arquitetura

O banco de dados roda isolado dentro das subnets privadas (`database_subnets`) da VPC provisionada pelo repositório `fiap-officine-kubernets`.
O acesso direto pela Internet é bloqueado, sendo acessível apenas pelos pods da aplicação no Kubernetes e pela Function Serverless (AWS Lambda de autenticação).

- **Documentação detalhada da arquitetura:** Consulte [docs/database-infrastructure.md](file:///c:/Users/phpra/projects/fiap-pos/docs/database-infrastructure.md).

---

## 📁 Estrutura do Repositório

```
fiap-officine-database/
├── terraform/
│   ├── versions.tf                       # Provider AWS (~> 6.0) e Random (~> 3.6)
│   ├── modules/
│   │   └── rds/                          # Módulo RDS PostgreSQL + Secrets Manager
│   └── environments/
│       ├── homolog/                      # 100% Free Tier (db.t4g.micro, 20GB gp3, Single-AZ)
│       └── production/                   # Produção Multi-AZ com retention ampliado
├── sql/
│   ├── 01_create_tables.sql              # DDL: clientes (CPF/status) e ordens_servico
│   └── 02_seed_data.sql                  # Carga de teste com CPFs válidos e O.S. nos 3 status
└── .github/workflows/
    └── terraform.yml                     # Pipeline CI/CD para validação e deploy automático
```

---

## 🚀 Como Executar Localmente

### 1. Inicializar e Planejar Homologação:
```bash
cd terraform/environments/homolog
terraform init
terraform plan
```

### 2. Aplicar a Infraestrutura:
```bash
terraform apply
```

### 3. Recuperar a Senha Gerada:
As credenciais são criadas aleatoriamente e armazenadas de forma segura no **AWS Secrets Manager**:
```bash
aws secretsmanager get-secret-value \
  --secret-id fiap-officine-homolog-db-credentials \
  --query SecretString \
  --output text \
  --region sa-east-1
```

### 4. Executar as Migrations DDL:
Conecte-se à instância do Kubernetes via AWS SSM e execute os scripts da pasta `sql/`:
```bash
psql -h <rds_endpoint> -U dbadmin -d officine_db -f sql/01_create_tables.sql
psql -h <rds_endpoint> -U dbadmin -d officine_db -f sql/02_seed_data.sql
```
