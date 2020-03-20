import boto3

def lambda_handler(event, context):
    client = boto3.client('ec2')
    instance_list = []
    ec2 = boto3.resource('ec2')

    instances = ec2.instances.filter(
        Filters=[{'Name': 'instance-state-name', 'Values': ['stopped']}])
    for instance in instances:
        instance_list.append(instance.instance_id)

    response = client.start_instances(
        InstanceIds=instance_list
    )
    print(response)


    return "Done"
