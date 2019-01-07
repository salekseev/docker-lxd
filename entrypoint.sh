#!/bin/bash

# Start the first process
/usr/bin/lxd --group lxd --logfile=/dev/stdout &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start lxd: $status"
  exit $status
fi

/usr/bin/lxd waitready --timeout=600
cat lxd-preseed.yaml | /usr/bin/lxd init --preseed
lxc config set core.trust_password "$LXD_PASSWD"

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60; do
  ps aux |grep lxd |grep -q -v grep
  LXD_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $LXD_STATUS -ne 0 ]; then
    echo "LXD exited."
    exit 1
  fi
done
