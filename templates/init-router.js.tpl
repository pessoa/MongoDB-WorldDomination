%{ for instance in instances ~}
sh.addShard("${split("-",instance[0].name)[2]}/${instance[0].ip_address}:27017")
%{ endfor ~}
