#!/bin/bash
git clone https://github.com/ghfalcon7/tb_load_test.git /root/tb_load_test
cd /root/tb_load_test
INSTANCE=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)
rank=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name load_test --region eu-west-3  --query 'AutoScalingGroups[*].Instances[*].[InstanceId]' --output text |sort|grep -n $INSTANCE | cut -d":" -f1)
rank=$(printf "%02d" $rank)
./mqtt-load-testing -broker tcp://a43d65bcf37b94c42835233b58cb4dc8-bdeaf8b09fa28444.elb.eu-west-3.amazonaws.com:1883 -connect-every-publish -delay-between-publish 20000 -topic 'v1/devices/me/telemetry' -number-of-messages 180 -csv heartbeat/$rank -rampup-duration 20 --reconnect-tries 15 -debug > log &
