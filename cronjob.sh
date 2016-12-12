#!/bin/bash
source $(dirname "$0")/config/cron.cfg
cd $(dirname "$0")/lib/tasks
echo $PWD >> $(dirname "$0")/log/cron.log
${HOME}/.rbenv/shims/rake cron >> ${NHL_HOME}/log/cron.log 2>&1
