#!/bin/bash
set -x
echo "*** Phase 11 - AD Integration Script Started at `date +'%Y-%m-%d_%H-%M-%S'` ***"

##Error handling functions
fail_if_error() {
  [ $1 != 0 ] && {
    echo $2
    exit 10
  }
}

#variable decleration
rdp_vm_name=`facter rdp_vm_name`
domain_name=`facter domain_name`
app_name=`facter app_name`
ad_user=`facter ad_user`
key_vault_name=`facter kv_vault_name`
sasint_secret_name=`facter saspwd`
meta_host=${app_name}`facter meta_name`.${domain_name}
compute_host=${app_name}`facter compute_name`.${domain_name}
mid_host=${app_name}`facter mid_name`.${domain_name}
ansible_host=${app_name}`facter ansible_vmname`.${domain_name}
microservices_host=${app_name}`facter microservices_vmname`.${domain_name}
controller_host=${app_name}`facter cascontroller_vmname`.${domain_name}
spre_host=${app_name}`facter spre_vmname`.${domain_name}
casworker_vm_name=`facter casworker_vmname`
cas_nodes=`facter cas_nodes`
input_file="all_hosts.txt"

#Getting the password for vmuser for AD Integration
az login --identity
fail_if_error $? "ERROR: Azure login failed"
ad_user_passwd=`az keyvault secret show -n $sasint_secret_name --vault-name $key_vault_name | grep value | cut -d '"' -f4`


#Building up the hosts file
echo "${ansible_host}
${meta_host}
${compute_host}
${mid_host}
${microservices_host}
${controller_host}
${spre_host}" >> ${input_file}
for ((i=1;i<=${cas_nodes};i++));
do
    casworker_host=$app_name$casworker_vm_name$i.$domain_name
    echo "$casworker_host" >> ${input_file}
done

cat << EOF >> ~/.ssh/config
Host *
    StrictHostKeyChecking no
EOF
sudo chmod 400 ~/.ssh/config

while IFS= read -r host
do
    ssh -tT root@${host} << EOF
    #Adding to resolve Active Directory server
    echo "nameserver `nslookup ${rdp_vm_name}.${domain_name}  | grep Address  | awk '{print $2}' | tail -1`" >> /etc/resolv.conf
    chattr +i /etc/resolv.conf 

    #Install adcli package along with sssd
    yum install sssd realmd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools krb5-workstation openldap-clients policycoreutils-python -y
    fail_if_error $? "ERROR: AD Integration Packages Install Failed"

    #Joining the Server wtih Active directory
    echo $ad_user_passwd| realm join --user=${ad_user} ${rdp_vm_name}.${domain_name}
    

    #Chaning the Configuration in sssd.conf
    if [ -f /etc/sssd/sssd.conf ]; then
        sed -i '/use_fully_qualified_names/c\use_fully_qualified_names = false'  /etc/sssd/sssd.conf
        sed -i '/fallback_homedir/c\fallback_homedir = /home/%u' /etc/sssd/sssd.conf
        systemctl restart sssd
    fi
EOF
done < "${input_file}"


echo "*** Phase 11 - AD Integration Script Script Ended at `date +'%Y-%m-%d_%H-%M-%S'` ***"