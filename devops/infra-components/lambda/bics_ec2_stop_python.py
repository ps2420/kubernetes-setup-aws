import boto3
import time

ec2_user_topic = 'arn:aws:sns:ap-southeast-1:893078813177:BICS_NOTIFICATION'

def lambda_handler(event, context):
    region = 'ap-southeast-1'
    instances = find_bics_instance_id()
    print('Stopping instance ids:' + instances + ", for region : " + region)

    ec2 = boto3.client('ec2', region_name=region)
    time.sleep(30)
    ec2.stop_instances(InstanceIds=[instances])
    time.sleep(15)
    print ('Stopping your instance-id ' + instances)
    send_notification()

def send_notification():
  lambda_client = boto3.client('sns')
  lambda_client.publish(
    TargetArn=ec2_user_topic,
    Subject='EC2 instance BICS_INFRA stop Notification',
    Message='EC2 instance BICS_INFRA has been stopped successfully'
  )
  print('EC2 instance BICS_INFRA stop notification has been sent')

def find_bics_instance_id():
    ec2client = boto3.client('ec2')
    response = ec2client.describe_instances(Filters=[{'Name' : 'tag:Name','Values' : ['BICS_INFRA']},
       {'Name' : 'tag:Partner','Values' : ['Amaris']}])

    insanceid = ''
    for reservation in response["Reservations"]:
      for instance in reservation["Instances"]:
        insanceid = instance["InstanceId"]

    return insanceid
