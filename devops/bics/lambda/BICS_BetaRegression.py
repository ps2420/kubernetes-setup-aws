import json
import boto3
import os
import time

ssm_client = boto3.client('ssm')
 
def lambda_handler(event, context):
  status = check_ec2_status_is_up()
  if status == 'running':
    print ('ec2 instance is up and running calling bics_code_base')
    trigger_bics_evaluation()

  print('ec2-instance status is : ' + status) 

def trigger_bics_evaluation():
  instanceid = find_bics_instance_id()
  print("calling function on ec2 instanceid : " + instanceid);
  
  response = ssm_client.send_command(
          InstanceIds=[instanceid],
          DocumentName="AWS-RunShellScript",
          Parameters={'commands': ['cd /home/ubuntu/bics && sudo -u ubuntu mkdir -p logs && sudo -u ubuntu UID=${UID} docker-compose up bics_gpu_docker > ./logs/lambda_bics_e2e_gpu.log']} )
  
  command_id = response['Command']['CommandId']
  time.sleep(10)
  output = ssm_client.get_command_invocation(
    CommandId=command_id,
    InstanceId=instanceid,
  )
  print(output)


def find_bics_instance_id():
  ec2client = boto3.client('ec2')
  response = ec2client.describe_instances(Filters=[{'Name' : 'tag:Name','Values' : ['BICS_INFRA']},
     {'Name' : 'tag:Partner','Values' : ['Amaris']}])
  
  instanceid = ''
  for reservation in response["Reservations"]:
    for instance in reservation["Instances"]:
      instanceid = instance["InstanceId"]
      
  return instanceid
    
def check_ec2_status_is_up():
  status = bics_ec2_instance_current_status()
  while (status != 'running'):
    time.sleep(10)
    status = bics_ec2_instance_current_status()
    print ('status : ' + status)
    
  print('ec2-instance status is : ' + status)  
  return status;

def bics_ec2_instance_current_status():
  ec2client = boto3.client('ec2')
  response = ec2client.describe_instances(Filters=[{'Name' : 'tag:Name','Values' : ['BICS_INFRA']},
     {'Name' : 'tag:Partner','Values' : ['Amaris']}])
  
  for reservation in response["Reservations"]:
    for instance in reservation["Instances"]:
      return (instance["State"]["Name"])    