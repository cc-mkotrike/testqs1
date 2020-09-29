#!/bin/bash

##Error handling functions
fail_if_error() {
  [ $1 != 0 ] && {
    echo $2
    exit 10
  }
}

#Variables declaration
viyassl_path="/opt/viya_ssl"
artifact_loc=`facter artifact_loc`
app_name=`facter app_name`
domain_name=`facter domain_name`
microservices_vm_name=`facter microservices_vmname`
microservice_host=$app_name$microservices_vm_name.$domain_name
spre_vm_name=`facter spre_vmname`
spre_host=$app_name$spre_vm_name.$domain_name
cascontroller_vm_name=`facter cascontroller_vmname`
cas_host=$app_name$cascontroller_vm_name.$domain_name
casworker_vm_name=`facter casworker_vmname`
nodes=`facter cas_nodes`
ag_ssl_yml=${artifact_loc}ansible/playbooks/viya_agw_ssl_certs.yaml
viya_ssl_yml=${artifact_loc}ansible/playbooks/viya_ssl_certs.yaml
agw_hostname=`facter agw_hostname`
FILE_SSL_JSON_FILE="${viyassl_path}/loadbalancer.pfx.json"
FILE_CA_B64_FILE="${viyassl_path}/sas_certificate_all.crt.b64.txt"

#constructing all_servers file
m=1
for s in ${microservice_host} ${spre_host} ${cas_host}
do
    echo "$s" >> hosts.txt
    echo "        DNS.$m = $s" >> all_servers.txt
    let "m+=1"
done
#for ((i=0; i < $nodes ; i++))
for ((i=1;i<=${nodes};i++));
do
    casworker_host=$app_name$casworker_vm_name$i.$domain_name
    echo "$casworker_host" >> hosts.txt
    n=$(($i+3)) 
    echo "        DNS.$n = $casworker_host" >> all_servers.txt
done
echo " " >> all_servers.txt
j=1
for s in ${microservice_host} ${spre_host} ${cas_host}
do
    echo "        IP.$j = `nslookup $s  | grep Address  | awk '{print $2}' | tail -1`" >> all_servers.txt
    let "j+=1"
done
#for ((i=0; i < $nodes ; i++))
for ((i=1;i<=${nodes};i++));
do
    casworker_host=$app_name$casworker_vm_name$i.$domain_name
    n=$(($i+3))
    echo "        IP.$n = `nslookup $casworker_host  | grep Address  | awk '{print $2}' | tail -1`" >> all_servers.txt
done


if [ ! -d "$viyassl_path" ]; then
    mkdir -p $viyassl_path
    fail_if_error $? "ERROR: $viyassl_path directory creation failed"
fi

if [[ -z "$SCRIPT_PHASE" ]]; then
        SCRIPT_PHASE="$1"
fi

if [[ "$SCRIPT_PHASE" -eq 1 ]]; then
    #Downloading and running agw certs yaml script
    wget $ag_ssl_yml
    sed -i "s/dynamicagwhostname/${agw_hostname}/g" viya_agw_ssl_certs.yaml
    ansible-playbook viya_agw_ssl_certs.yaml -vvv
    fail_if_error $? "ERROR: AppGateway Certificates creation failed"
    
    #Downloading and running viya ssl certs yaml script
    wget $viya_ssl_yml
    sed -i "/\[ alt_names \]/r all_servers.txt" viya_ssl_certs.yaml
    ansible-playbook viya_ssl_certs.yaml -vvv
    fail_if_error $? "ERROR: SAS Viya Certificates creation failed"
    
    #changing the certficates permission
    chmod 600 $viyassl_path/localhost.*
    #copying server certificates to all the servers
    input_file="hosts.txt"
    while IFS= read -r host
    do
        scp -o StrictHostKeyChecking=no $viyassl_path/localhost.crt ${host}:/etc/pki/tls/certs
        fail_if_error $? "ERROR: Failed to copy the certificate to remote ${host}"
        scp -o StrictHostKeyChecking=no $viyassl_path/localhost.key ${host}:/etc/pki/tls/private
        fail_if_error $? "ERROR: Failed to copy the key to remote ${host}"
        ssh -tT root@${host} << EOF
        yum install httpd mod_ssl -y
        systemctl enable httpd && systemctl restart httpd
EOF
    done < "$input_file"
elif [[ "$SCRIPT_PHASE" -eq "2" ]]; then
	cat "${FILE_SSL_JSON_FILE}.1" |tr -d '\n'
elif [[ "$SCRIPT_PHASE" -eq "3" ]]; then
	cat "${FILE_SSL_JSON_FILE}.2" |tr -d '\n'
elif [[ "$SCRIPT_PHASE" -eq "4" ]]; then
    cat "$FILE_CA_B64_FILE"|tr -d '\n'
fi