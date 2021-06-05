#!/bin/bash 

echo "[TASK 1] Enable ssh password authentication"
sed -i.bak 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo -e '\nPermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload-or-restart sshd

# Set Root password
echo "[TASK 2] Set root password"
echo -e "password" | passwd --stdin root >/dev/null 2>&1
