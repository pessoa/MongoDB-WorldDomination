# Private addresses
output "config-server-private" {
  value = {
    for instance in stackpath_compute_workload.mc.instances :
    instance.name => {
      "ip_address" = instance.ip_address
    }
  }
}

output "shards-private" {
  value = [
    for index, instance in module.md.md-workload-instances :
      {for index, instance in module.md.md-workload-instances[index] :
      instance.name => {
        "ip_address" = instance.ip_address
      }
    }
  ]
}

output "routers-private" {
  value = {
    for instance in stackpath_compute_workload.router.instances :
    instance.name => {
      "ip_address" = instance.ip_address
    }
  }
}

# Private addresses
output "config-server-public" {
  value = {
    for instance in stackpath_compute_workload.mc.instances :
    instance.name => {
      "ip_address" = instance.external_ip_address
    }
  }
}

output "shards-public" {
  value = [
    for index, instance in module.md.md-workload-instances :
      {for index, instance in module.md.md-workload-instances[index] :
      instance.name => {
        "ip_address" = instance.external_ip_address
      }
    }
  ]
}

output "routers-public" {
  value = {
    for instance in stackpath_compute_workload.router.instances :
    instance.name => {
      "ip_address" = instance.external_ip_address
    }
  }
}

# Anycast
output "router-anycast-ip" {
  value = replace(lookup(stackpath_compute_workload.router.annotations, "anycast.platform.stackpath.net/subnets", ""), "/32", "")
}
