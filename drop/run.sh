#!/bin/bash

echo "******************* Starting Mongo Instance ********************"
mongod --smallfiles --rest --fork --logpath /var/log/mongodb/server.log
sleep 7
echo "******************* Dumping Data ********************"
mongo ordering /usr/local/app/MongoRecords.js
echo "******************* Starting to log ********************"
tail -f /var/log/mongodb/server.log
