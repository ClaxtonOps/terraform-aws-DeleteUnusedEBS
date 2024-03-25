Módulo Terraform que utiliza EventBridge, SNS e Lambda Function. A função lambda deleta todos os volumes que não estão sendo utilizados, exceto aqueles que contêm a tag “Environment” com a lista de ambientes como Dev, Prod, Staging, etc. O SNS só será acionado caso ocorra algum erro na execução do Lambda, garantindo que um e-mail com o log do problema seja enviado.

O objetivo é evitar gastos desnecessários com EBS que não estão sendo utilizados e que não fazem parte do ambiente adequado.

## Como utilizar?

1. [Acesse o Registry Module do Terraform](https://registry.terraform.io/modules/ClaxtonOps/DeleteUnusedEBS/aws/latest), vá para "Provision Instructions", e copie o módulo "DeleteUnusedEBS".
2. Dentro do escopo do modulo, defina os valores das variáveis obrigatórias listadas em Inputs.
3. Depois de configurar o módulo, utilize os comandos básicos do Terraform (init, plan, apply) para baixar o plugin/modulo, e dar deploy no projeto.

## Exemplo de uso
```
module "DeleteUnusedEBS" {
source  = "ClaxtonOps/DeleteUnusedEBS/aws"
version = "1.0.0" // Versão do Modulo. Confirme no registry terraform se esta correto.

region           = "us-east-1" // Região que contém os recursos.
email            = "paulo@gmail.com" // E-mail para receber o log em caso de erro na execução do Lambda. (Confirme a inscrição no SNS.)
tag_environments = ["Dev", "Prod", "QA"] // Valor da tag "Environment".
trigger_cron     = "cron(00 10 ? * * *)" // Formato UTC. Cron que acionará o Lambda.
}

```
em "tag_environments", pode ser qualquer valor que esteja em conformidade com o valor de "Environment" na tag.

## IMPORTANTE: Certifique-se de que você especificou o ambiente correto na tag "tag_environments". Caso contrário, quando a função for acionada e o EBS não estiver com a tag corretamente definida e não estiver em uso, ele será deletado.
Exemplo:
Key="Environment"
Value="Dev"

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.4.2 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.41.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.daily_trigger_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.iam_policy_for_lambda_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_role_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.lambda_error_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.lambda_error_email_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [random_uuid.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [archive_file.zip_the_python_code](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_email"></a> [email](#input\_email) | Email address to be notified in case of Lambda loading error. Example: paulo@gmail.com | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region that will contain the resources. Example: 'us-east-1' | `string` | n/a | yes |
| <a name="input_tag_environments"></a> [tag\_environments](#input\_tag\_environments) | List of permitted environments for the Lambda. The Lambda will delete any EBS not belonging to these environments. Example: ['Dev', 'Staging', 'Prod'] | `list(string)` | n/a | yes |
| <a name="input_trigger_cron"></a> [trigger\_cron](#input\_trigger\_cron) | Time to trigger the Lambda by EventBridge. Example: cron(36 16 ? * * *) | `string` | n/a | yes |

## Outputs

No outputs.
