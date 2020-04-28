rs.initiate(
   {
      _id: "configserver",
      configsvr: true,
      version: 1,
      members: [
%{ for index, name in names ~}
         { _id: ${index}, host : "${name}.${stack}.edgeengine.internal:27019" },
%{ endfor ~}
      ]
   }
)
