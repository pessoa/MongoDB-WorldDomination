output "mc-workload-instances" {
  value = {
    for instance in stackpath_compute_workload.mc.instances :
    instance.name => {
      "ip_address" = instance.external_ip_address
    }
  }
}

output "md-workload-instances" {
  value = [
    for index, instance in module.md.md-workload-instances :
      {for index, instance in module.md.md-workload-instances[index] :
      instance.name => {
        "ip_address" = instance.external_ip_address
      }
    }
  ]
}

output "router-workload-instances" {
  value = {
    for instance in stackpath_compute_workload.router.instances :
    instance.name => {
      "ip_address" = instance.external_ip_address
    }
  }
}

output "mongos-anycast-ip" {
  value = replace(lookup(stackpath_compute_workload.router.annotations, "anycast.platform.stackpath.net/subnets", ""), "/32", "")
}
