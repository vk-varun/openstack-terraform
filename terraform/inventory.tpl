[control]
%{ for ip in controllers ~}
${ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3 ansible_ssh_private_key_file=~/.ssh/google_compute_engine
%{ endfor ~}

[compute]
%{ for ip in computes ~}
${ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3 ansible_ssh_private_key_file=~/.ssh/google_compute_engine
%{ endfor ~}

[network]
%{ for ip in networks ~}
${ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3 ansible_ssh_private_key_file=~/.ssh/google_compute_engine
%{ endfor ~}

[storage]
%{ for ip in storages ~}
${ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3 ansible_ssh_private_key_file=~/.ssh/google_compute_engine
%{ endfor ~}

[loadbalancer]
%{ for ip in controllers ~}
${ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3 ansible_ssh_private_key_file=~/.ssh/google_compute_engine
%{ endfor ~}


