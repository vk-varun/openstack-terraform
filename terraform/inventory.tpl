[control]
%{ for ip in controllers ~}
${ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}

[compute]
%{ for ip in computes ~}
${ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}

[network]
# (optional) add dedicated network nodes later

[storage]
# (optional) add Ceph/storage nodes later

[deployment]
localhost ansible_connection=local
