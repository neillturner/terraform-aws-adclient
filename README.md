# terraform-aws-adclient

Create Active Directory Client EC2 instance to manage AWS Directory Service

# Overview

Creates an EC2 instances that is an ad client that can be used to administer the AWS Directory Service

* http://www.sanjeevnandam.com/blog/aws-microsoft-ad-setup-with-terraform
* https://aws.amazon.com/blogs/security/how-to-configure-your-ec2-instances-to-automatically-join-a-microsoft-active-directory-domain/
* https://forums.aws.amazon.com/thread.jspa?threadID=181520

## Requirements

This module requires Terraform version `0.10.x` or newer.

## Dependencies

This module depends on a correctly configured [AWS Provider](https://www.terraform.io/docs/providers/aws/index.html) in your Terraform codebase.

## Usage

### Access

* The ad_client instance can be stopped when not in use
* To use the ad_client first start the instance with the aws console.
* login with your active directory domain Adminstrator account.
* Go to a Command prompt

### AD maintenance Using GUI

You add/delete users, groups or computers  as per: http://docs.aws.amazon.com/directoryservice/latest/admin-guide/creating_ad_users_and_groups.html
* run from command prompt %SystemRoot%\system32\dsa.msc

### AD maintenance using the command line

See https://support.microsoft.com/en-ie/help/322684/how-to-use-the-directory-service-command-line-tools-to-manage-active-d

These commands will work for both SimpleAD (Samba4) and MicrosoftAD

delete a computer TESTWEB from AD run command:
* dsrm -noprompt "CN=TESTWEB,CN=computers,DC=corp,DC=example,DC=com"

list all the servers in the domain:
* dsquery computer DC=corp,D=Cexample,DC=com

### DNS maintenance Using GUI

See Managing DNS In Windows Server 2012 http://krypted.com/windows-server/managing-dns-in-windows-server-2012/
* run from command prompt:  %SystemRoot%\system32\dnsmgmt.msc  /ComputerName 172.99.99.99  (where 172.99.99.99 is IP address of on the of the AD servers)

### DNS maintenance using the command line

See https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dnscmd

Create a DNS entry for testweb.corp.example.com (where 172.99.99.99 is IP address of on the of the AD servers)
* dnscmd 172.99.99.99 /recordadd corp.example.com TESTWEB A 172.10.60.54


## Automted Setup Process

The terraform code will install the AD client software and join the Active Directory Domain on Startup.

## Test if server is on the domain.

* Logon with AD Domain Administrator or Local Administrator
* In Windows Explorer Right click on Computer and select Properties
* It will show if it is in a Domain. It will show WORKGROUP if not in a domain.

## Test if SSM Association worked

$instanceId = Invoke-RestMethod -uri http://169.254.169.254/latest/meta-data/instance-id
Get-SSMAssociation -InstanceId $instanceId -Name 'ssm_document_my_ad'

## SSM Logs

Check logs at c:/ProgramData/Amazon/SSM/Logs

# OUTSTANDING

## Need to cleanup the Active Directory for instances that have been terminated

Need a way of finding all the machine names of instances are active (i.e. they exist in AWS and are not terminated).
Then goes through Active Directory and delete all commputers that aren't active.
SimpleAD does not support the Powershell AD interface so need to use dsrm command

See https://serverfault.com/questions/631754/how-can-i-see-the-windows-computer-name-for-an-ec2-instance-without-logging-in-v
