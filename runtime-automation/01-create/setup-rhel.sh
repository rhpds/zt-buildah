#!/bin/sh
echo "Starting module called 01-create" >> /tmp/progress.log

KATELLO=$(rpm -qa | grep katello-ca)

rpm -e $KATELLO
subscription-manager clean
subscription-manager register --activationkey=12-5-22-instruqt --org=12451665 --force
