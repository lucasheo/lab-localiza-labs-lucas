# LAB LOCALIZA  


## Arquitetura da Solução

Abaixo está a representação da arquitetura da solução:

![Arquitetura AWS](lucasheo.png)


# Projeto de Infraestrutura com Terraform

Este README documenta a implementação de uma infraestrutura em AWS utilizando Terraform, com foco em uma configuração modular e escalável. A infraestrutura provê uma solução completa para serviços como VPC, RDS, Lambda@Edge e CloudFront.

## Visão Geral dos Módulos

O projeto foi organizado em módulos para facilitar a manutenção e a escalabilidade:

1. **CloudFront**: Configuração de distribuição de conteúdo, com suporte para S3 como origem e regras de cache.
2. **Lambda**: Funções Lambda associadas a eventos do CloudFront para manipulação e processamento de requisições.
3. **RDS**: Banco de dados relacional configurado com alta disponibilidade e segurança.
4. **VPC**: Rede privada e pública para isolar recursos, incluindo subnets, rotas e controle de acesso.

## Estrutura dos Arquivos

### Arquivo `main.tf`

Cada módulo possui seu próprio `main.tf`, onde os recursos específicos são configurados.

- **CloudFront/main.tf**: Configura o bucket S3 como origem e define a distribuição do CloudFront com comportamentos de cache e controle de acesso.
- **Lambda/main.tf**: Configura funções Lambda para interações com o CloudFront, incluindo papéis IAM e permissões de log no CloudWatch.
- **RDS/main.tf**: Utiliza o módulo oficial de RDS para configurar um banco MySQL com autenticação IAM.
- **VPC/main.tf**: Configura a VPC usando o módulo oficial, com subnets privadas e públicas, aproveitando as zonas de disponibilidade da região configurada.

### Arquivo `variables.tf`

Cada módulo também possui um `variables.tf`, onde as variáveis de entrada são definidas.

- **CloudFront/variables.tf**: Define variáveis para certificados ACM e tags.
- **Lambda/variables.tf**: Configura tags para monitoramento e gerenciamento.
- **RDS/variables.tf**: Define variáveis para identificação do banco, conjunto de caracteres, e configurações específicas.
- **VPC/variables.tf**: Configura a região AWS, nome da VPC, subnets privadas e tags.

### Arquivo `provider.tf`

Define o provedor AWS para conexão com a infraestrutura, com a região especificada.

### Arquivo `versions.tf`

Especifica a versão do Terraform e dos provedores para garantir compatibilidade entre os módulos e o ambiente de execução.

## Pré-requisitos

- **Terraform** versão especificada em `versions.tf`
- **Credenciais AWS** configuradas
- **Permissões AWS** adequadas para criação e modificação dos recursos

## Explicação dos Principais Recursos

- **CloudFront**: Configura uma distribuição com origem S3 e manipulação de requests via Lambda@Edge para otimização de cache e segurança.
- **Lambda**: Funções Lambda para CloudFront, gerenciando ações como visualização e respostas de origem, com permissões detalhadas no CloudWatch.
- **RDS**: Banco de dados MySQL configurado com autenticação IAM e políticas de segurança, aproveitando o módulo Terraform para RDS.
- **VPC**: Criação de subnets e rotas dentro de uma VPC dedicada, segmentando redes públicas e privadas para segurança e gerenciamento de tráfego.

## Considerações de Segurança

Revisar permissões de IAM, políticas de acesso em CloudFront e controle de acesso nas subnets da VPC para garantir a segurança e a conformidade dos recursos provisionados.
