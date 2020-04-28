variable "locations" {
  type        = list
}

resource "stackpath_compute_workload" "md" {
  count = length(var.locations)
  name  = "md-shard-${lower(var.locations[count.index])}"
  slug  = "md-shard-${lower(var.locations[count.index])}"

  # Define multiple labels on the workload container.
  # access is used in the network policy
  labels = {
    "role"   = "data-node"
    "access" = "private"
  }

  network_interface {
    network = "default"
  }

  container {
    # Name that should be given to the container
    name = "mongo"
    # image to use for the container
    image = "mongo:latest"
    # Override the command that's used to execute
    # the container. If this option is not provided
    # the default entrypoint and command defined
    # by the docker image will be used.
    command = ["/usr/bin/mongod", "--bind_ip_all", "--port", "27017", "--shardsvr", "--replSet", lower(var.locations[count.index])]
    resources {
      requests = {
        "cpu"    = "1"
        "memory" = "2Gi"
      }
    }
    port {
      # name that is given to the container port
      name = "mongo"
      # the port number that should be opened on
      # the container.
      port = 27017
      # The protocol that should be allowed the
      # port that is expose. This option must be
      # "TCP" (default) or "UDP".
      protocol = "TCP"
    }
  }

  target {
    name             = "md"
    min_replicas     = 2
    deployment_scope = "cityCode"
    selector {
      key      = "cityCode"
      operator = "in"
      values = [ "${var.locations[count.index]}" ]
    }
  }
}

resource "local_file" "init_md" {
  count = length(var.locations)
  content  = templatefile("${path.module}/templates/init-shard.js.tpl", { ip_addrs = stackpath_compute_workload.md[count.index].instances[*].ip_address, shard_id = lower(var.locations[count.index])})
  filename = "${path.root}/scripts/init-shard-${lower(var.locations[count.index])}.js"
}

output "md-workload-instances" {
  value = stackpath_compute_workload.md.*.instances
}