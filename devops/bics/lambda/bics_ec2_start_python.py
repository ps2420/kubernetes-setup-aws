import boto3
import time

ec2_status_topic = 'arn:aws:sns:ap-southeast-1:893078813177:BICS_EC2_NOTIFICATION'
ec2_user_topic = 'arn:aws:sns:ap-southeast-1:893078813177:BICS_NOTIFICATION'

def lambda_handler(event, context):
  region = 'ap-southeast-1'
  instances = find_bics_instance_id()

  print('Starting instance ids:' + instances + ", for region : " + region)
  ec2 = boto3.client('ec2', region_name=region)
  ec2.start_instances(InstanceIds=[instances])
  time.sleep(200)
  print ('Starting on your instance-id ' + instances)
  send_notification()


def send_notification():
  lambda_client = boto3.client('sns')
  lambda_client.publish(
    TargetArn=ec2_status_topic,
    Subject='EC2 instance BICS_INFRA Start Notification',
    Message='EC2 instance BICS_INFRA has been started successfully'
  )

  print('EC2 instance start notification has been sent')

def find_bics_instance_id():
  ec2client = boto3.client('ec2')
  response = ec2client.describe_instances(Filters=[{'Name' : 'tag:Name','Values' : ['BICS_INFRA']},
     {'Name' : 'tag:Partner','Values' : ['Amaris']}])

  instanceid = ''
  for reservation in response["Reservations"]:
    for instance in reservation["Instances"]:
      instanceid = instance["InstanceId"]

  return instanceid
