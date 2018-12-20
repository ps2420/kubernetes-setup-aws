import json
import boto3
import os
import time

ssm_client = boto3.client('ssm')


def lambda_handler(event, context):

    instanceid = find_bics_instance_id()
    print("calling function on ec2 instanceid : " + instanceid);

    response = ssm_client.send_command(
        InstanceIds=[instanceid],
        DocumentName="AWS-RunShellScript",
        Parameters={'commands': ['cd /home/ubuntu/bics && git checkout development && git pull && ' +
                                 'sudo -u ubuntu mkdir -p logs && sudo -u ubuntu bash ./bin/run_image_build.sh > ./logs/lambda_build_image.log']})

    command_id = response['Command']['CommandId']
    time.sleep(10)
    output = ssm_client.get_command_invocation(
        CommandId=command_id,
        InstanceId=instanceid,
    )
    print(output)


def find_bics_instance_id():
    ec2client = boto3.client('ec2')
    response = ec2client.describe_instances(Filters=[{'Name': 'tag:Name', 'Values': ['BICS_INFRA']},
                                                     {'Name': 'tag:Partner', 'Values': ['Amaris']}])

    insanceid = ''
    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            insanceid = instance["InstanceId"]

    return insanceid
