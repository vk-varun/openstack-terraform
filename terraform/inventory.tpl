[control]
%{ for ip in controllers ~}
${ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}

[compute]
%{ for ip in computes ~}
${ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}

[network]
%{ for ip in networks ~}
${ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}

[storage]
%{ for ip in storages ~}
${ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3
%{ endfor ~}

[deployment]
localhost ansible_connection=local
