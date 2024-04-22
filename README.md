# Deploying LAMP stack using vagrant VMs

## Setup machines in [Vagrantfile](/Vagrantfile)
![vagrant file screenshot](vagrantfile_sc.png)

## Provision VMs

`vagrant up`
 
## Check status and ssh into master

`vagrant status`

![status](status.png)

## Get machines IP addresses

`ip addr`

![master ip](masterip.png)
![slave ip](slaveip.png)

```
Master: 192.168.56.31
Slave: 192.168.56.33
```

## Generate ssh key for master and copy to slave

`ssh-keygen`

`ssh-copy-id root@192.168.56.33`

![slave auth file](slaveauth.png)


## Install ansible on master, setup [hosts](/hosts) file and test connection

![hosts file](hosts.png)

`ansible all -m ping`

![ping](pingslave.png)

## Create [Ansible Playbook](/run_deploy_script.yml)

![playbook](playbook.png)

## Run [Deployment Bashscript](/deploy.sh) 


![play](play.png)


![installed services](services.png)


![laravel project](laravelproject.png)


![bash script copy](bashcopy.png)


![deployed page](laravelpage.png)


![uptime cron job](cronjob.png)


![log file](logfile.png)




