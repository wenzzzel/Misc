#!/usr/bin/env zsh
set -u

NAMESPACE="put namespace here"
QUEUE="put queue name here"
BATCH_SIZE=10
RUNS=1000
DELAY=5

for i in {1..$RUNS}; do
  echo "=== Run $i/$RUNS - $(date '+%Y-%m-%d %H:%M:%S') ==="
  
  expect <<EOF
set timeout 30
spawn servicebus-cli deadletter resend $NAMESPACE $QUEUE $BATCH_SIZE
expect {
  "want to continue?" { send "y\r"; exp_continue }
  eof
}
EOF

  if (( i < RUNS )); then
    sleep "$DELAY"
  fi
done

echo "Done: $RUNS runs completed."
