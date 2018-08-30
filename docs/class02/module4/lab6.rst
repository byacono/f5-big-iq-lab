Lab 4.6: Troubleshooting (AWS)
------------------------------

Here are some Troubleshooting steps to help you troubleshooting issue with your AWS SSG deployment and Application:

1. In BIG-IQ UI, if the application deployment failed, click Retry.
2. In BIG-IQ UI, check BIG-IQ license on Console Node and Data Collection Device (System > THIS DEVICE > Licensing) and BIG-IP license pool (Devices > LICENSE MANAGEMENT > Licenses).
3. In BIG-IQ UI, check the Cloud Environment if all the information are populated correctly (Applications > ENVIRONEMENTS > Cloud Environments).
4. In BIG-IQ CLI, check following logs: /var/log/restjavad.0.log and /var/log/orchestrator.log.
5. In AWS Marketplace, check if you have subscribed and accepted the terms for the F5 products.
6. In AWS CFT Console, check the CFT status, make sure it is COMPLETED with no errors.
7. In AWS IAM Console, confirm the Access Key has the necessary permissions.
8. In AWS EC2 Console, check the Activity History in the Auto Scaling Group.
9. In AWS EC2 Console, check the Instances in the Auto Scaling Group and confirm ``Protected from`` has at least 1 instance with *Scale-in*
