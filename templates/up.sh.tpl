# Create the Config Server Replica Set
mongo --host "${mc_ip}" --port 27019 scripts/init-configserver.js

# Create the Shard Replica Sets
%{ for index, ip in md_ip_addrs ~}
mongo --host "${ip}" --port 27017 scripts/init-shard-${lower(locations[index])}.js
%{ endfor ~}

# wait for the elections of the replica sets to take place
sleep 15

# Start a mongos for the Sharded Cluster
mongo --host "${router_ip}" --port 27017 scripts/init-router.js
