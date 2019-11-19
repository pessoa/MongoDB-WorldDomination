rs.initiate(
   {
      _id: "configserver",
      configsvr: true,
      version: 1,
      members: [
%{ for index, ip in ip_addrs ~}
         { _id: ${index}, host : "${ip}:27019" },
%{ endfor ~}
      ]
   }
)
