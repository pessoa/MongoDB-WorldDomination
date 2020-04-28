rs.initiate(
   {
      _id: "${shard_id}",
      version: 1,
      members: [
%{ for index, name in names ~}
         { _id: ${index}, host : "${name}.${stack}.edgeengine.internal:27017" },
%{ endfor ~}
      ]
   }
)
