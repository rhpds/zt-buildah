#!/bin/bash

dnf -y install buildah podman
buildah rm -a
setsebool -P container_manage_cgroup true

systemctl stop httpd
systemctl disable httpd

podman image rm rhel8-httpd

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