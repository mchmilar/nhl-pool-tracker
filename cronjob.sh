#!/bin/bash
NHL_HOME=/home/emarchm/Work/rails-projects/RubymineProjects/nhl-pool-tracker
cd ${NHL_HOME}/lib/tasks
RAILS_ENV=development
rake cron --silent > ${NHL_HOME}/log/cron.log 2>&1
