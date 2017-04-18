#!/bin/bash

# Runs mongo in under different conditions
# such as w/o custom db and/or log path, and/or w/o custom volume
# if the server is not bootstrapped (users and data init-ed), it will be

set -e

DB_PATH=${DB_PATH:-"/data/db"}
LOG_PATH=${LOG_PATH:-"/var/log/mongodb/"}

printf "++ Using DB Path:$DB_PATH and LOG Path:$LOG_PATH \n"

if ! [ -e $DB_PATH/bootstrap_done ]; then
  printf "++ This server is not bootstraped!, bootstrapping\n"

  [ -e $DB_PATH ] || mkdir -p $DB_PATH && chown mongodb:mongodb $DB_PATH
  [ -e $LOG_PATH ] || mkdir -p $LOG_PATH && chown mongodb:mongodb $LOG_PATH

  mongod --smallfiles \
         --rest \
         --fork \
         --logpath ${LOG_PATH}server.log \
         --dbpath ${DB_PATH} 

  # Create the db
  printf "++ Creating Database\n"
  mongo  ordering /usr/local/app/MongoRecords.js

  # Create the user 
  printf "++ Creating Web User\n"
  mongo  /usr/local/app/MongoAuth.js

  # Mark
  touch $DB_PATH/bootstrap_done
  # Shutdown and prepare to start in auth mode
  mongod --dbpath $DB_PATH  --shutdown 
  printf  "++ bootstrap done!, restarting into authenticated mode\n" 
fi 

printf "++ Start Server in Auth Mode\n"

mongod --auth \
       --smallfiles \
       --rest \
       --fork \
       --logpath ${LOG_PATH}server.log \
       --dbpath ${DB_PATH} 

printf "++ Watch logs\n\n"
tail -f ${LOG_PATH}/server.log
