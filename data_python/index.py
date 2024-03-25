import boto3
import os

def get_all_ebs_volumes():
    ec2 = boto3.resource('ec2')
    return ec2.volumes.all()

def delete_ebs_volume(volume_id):
    ec2 = boto3.resource('ec2')
    volume = ec2.Volume(volume_id)
    # Verificar se o volume está associado a uma instância antes de tentar excluí-lo
    if volume.attachments:
        print(f"Volume {volume_id} está atualmente em uso e não pode ser excluído.")
        return False
    volume.delete()
    return True

def send_notification(message):
    sns = boto3.client('sns')
    sns_topic_arn = os.environ.get('SNS_TOPIC_ARN')
    sns.publish(TopicArn=sns_topic_arn, Message=message)

def lambda_handler(event, context):
    try:
        environments = os.environ.get('ENVIRONMENTS', '').split(',')
        print(f"Valores de ambiente: {environments}")  # Verificar valores de ambiente
        volumes = get_all_ebs_volumes()
        
        deleted_volumes = []  # Lista para armazenar os IDs dos volumes excluídos
        
        for volume in volumes:
            tags = {tag['Key']: tag['Value'] for tag in volume.tags or []}
            # Verifica se a tag 'Environment' não está presente ou se o valor não está na lista de ambientes especificados
            if 'Environment' not in tags or tags['Environment'] not in environments:
                print(f"Tentando excluir volume {volume.id}...")
                if delete_ebs_volume(volume.id):
                    deleted_volumes.append(volume.id)  # Adiciona o ID do volume excluído à lista
        
        if deleted_volumes:  # Se houver volumes excluídos, enviar notificação
            error_message = f"Os volumes EBS foram excluídos: {', '.join(deleted_volumes)}"
            send_notification(error_message)
        
        return {
            'statusCode': 200,
            'body': 'Volumes excluídos com sucesso!'
        }
    except Exception as e:
        # Se ocorrer uma exceção, enviar notificação por e-mail usando o SNS
        error_message = f"Erro ao executar o Lambda: {str(e)}"
        print(error_message)
        send_notification(error_message)
        raise e  # Re-raise a exceção para que o Lambda registre o erro no CloudWatch Logs
