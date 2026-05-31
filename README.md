# azure

Aplicativo Spring Boot/Kotlin preparado para deploy no Azure Aplicativo de contêiner via GitHub Actions.

## Deploy no Azure

## Terraform

O Terraform está concentrado em um único arquivo:

- `main.tf`

### Aplicar a infraestrutura

```bash
terraform init
terraform plan
terraform apply
```

O Terraform cria só a base do ambiente:

- resource group
- Log Analytics workspace
- Azure Container Registry
- Container Apps Environment

O deploy da aplicação continua via GitHub Actions, como já estava.

### 1. Criar o app registration no Microsoft Entra ID

No portal do Azure:

1. Abra `Microsoft Entra ID`.
2. Vá em `App registrations`.
3. Clique em `New registration`.
4. Use um nome como `azure`.
5. Em `Supported account types`, selecione `Single tenant`.
6. Deixe `Redirect URI` vazio.
7. Clique em `Register`.
8. Abra o app criado.
9. Vá em `Certificates & secrets`.
10. Crie um `New client secret` e copie o `Value`.

### 2. Dados usados no GitHub Secrets

O workflow usa `AZURE_CREDENTIALS` com este formato:

```json
{
  "clientId": "<APPLICATION_CLIENT_ID>",
  "clientSecret": "<CLIENT_SECRET_VALUE>",
  "subscriptionId": "<SUBSCRIPTION_ID>",
  "tenantId": "<TENANT_ID>"
}
```

### 3. Comandos usados para habilitar o acesso no Azure

No terminal com Azure CLI:

```bash
az login
az account list -o table
az account show --query id -o tsv
az provider register --namespace Microsoft.ContainerRegistry
az provider register --namespace Microsoft.OperationalInsights --wait
az provider show --namespace Microsoft.ContainerRegistry --query registrationState -o tsv
az provider show --namespace Microsoft.OperationalInsights --query registrationState -o tsv
```

### 4. Conceder permissão ao service principal

O app registrado precisa de permissão na subscription ou no resource group.

```bash
az role assignment create \
  --assignee <APPLICATION_CLIENT_ID> \
  --role Contributor \
  --scope /subscriptions/<SUBSCRIPTION_ID>
```

### 5. Registrar o secret no GitHub

No repositório:

1. Vá em `Settings`.
2. Abra `Secrets and variables`.
3. Clique em `Actions`.
4. Crie o secret `AZURE_CREDENTIALS`.
5. Cole o JSON completo.

### 6. Verificar o deploy


No Azure Portal:

1. Abra `Aplicativo de contêiner`.
2. Selecione `azure-app`.
3. Confira `Status`, `Revisions`, `Ingress` e `Application URL`.

Teste o endpoint:

```bash
curl https://<sua-url-do-container-app>/teste
```

Resposta esperada:

```text
hello world
```

## Observação

O `clientSecret` deve ser rotacionado se tiver sido exposto fora do GitHub Secrets.
