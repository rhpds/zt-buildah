#!/bin/bash
while [ ! -f /opt/instruqt/bootstrap/host-bootstrap-completed ]
do
    echo "Waiting for Instruqt to finish booting the VM"
    sleep 1
done

dnf -y install buildah podman
buildah rm -a
setsebool -P container_manage_cgroup true

systemctl stop httpd
systemctl disable httpd

podman image rm rhel8-httpd

subscription-manager config --rhsm.manage_repos=1
subscription-manager register --activationkey=${ACTIVATION_KEY} --org=12451665 --force

echo "Adding wheel" > /root/post-run.log
usermod -aG wheel rhel

echo "setting password" >> /root/post-run.log
echo redhat | passwd --stdin rhel

cat >> ~/index1.html <<-EOF

<!DOCTYPE html>
<head>
  <title>Welcome to a container!</title>
</head>
<body>
<h1>You've deployed your new web application into a UBI based container!</h1>
</body>
EOF

cat >> ~/index2.html <<-EOF

<!DOCTYPE html>
<head>
  <title>Welcome to a container!</title>
</head>
<body>
<h1>You've deployed your new web application into a container from scratch!</h1>
</body>
EOF

#set up tmux so it has to restart itself whenever the system reboots

#step 1: make a script
tee ~/startup-tmux.sh << EOF
TMUX='' tmux new-session -d -s 'buildah-session' > /dev/null 2>&1
tmux set -g pane-border-status top
tmux setw -g pane-border-format ' #{pane_index} #{pane_current_command}'
tmux set -g mouse on
tmux set mouse on
EOF

#step 2: make it executable
chmod +x ~/startup-tmux.sh
#step 3: use cron to execute 
echo "@reboot ~/startup-tmux.sh" | crontab -

#step 4: start tmux for the lab
~/startup-tmux.sh