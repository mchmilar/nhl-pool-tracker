#!/bin/bash
source $(dirname "$0")/config/cron.cfg
cd $(dirname "$0")/lib/tasks
/bin/date >> $(dirname "$0")/log/cron.log
${HOME}/.rbenv/shims/rake cron >> $(dirname "$0")/log/cron.log 2>&1
echo "" >> $(dirname "$0")/log/cron.log
