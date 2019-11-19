rs.initiate(
   {
      _id: "${shard_id}",
      version: 1,
      members: [
%{ for index, ip in ip_addrs ~}
         { _id: ${index}, host : "${ip}:27017" },
%{ endfor ~}
      ]
   }
)
