%{ for instance in instances ~}
sh.addShard("${split("-",instance[0].name)[2]}/${instance[0].name}.${stack}.edgeengine.internal:27017")
%{ endfor ~}
