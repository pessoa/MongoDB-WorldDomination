resource "stackpath_compute_workload" "mc" {
  name = "mc"
  slug = "mc"

  # Define multiple labels on the workload container.
  # access is used in the network policy
  labels = {
    "role"   = "config-node"
    "access" = "private"
  }

  # Define the network interfaces that should be provisioned for the workload
  # instances. StackPath only supports a "default" network for edge compute
  # workloads.
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
    command = ["/usr/bin/mongod", "--bind_ip_all", "--port", "27019", "--configsvr", "--replSet", "configserver"]
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
      port = 27019
      # The protocol that should be allowed the
      # port that is expose. This option must be
      # "TCP" (default) or "UDP".
      protocol = "TCP"
    }
  }

  # the config servers go to 3 different continents
  target {
    name             = "configserver"
    min_replicas     = 1
    deployment_scope = "cityCode"
    selector {
      key      = "cityCode"
      operator = "in"
      values = [ "DFW", "FRA", "HKG" ]
    }
  }
}

resource "local_file" "init_configserver" {
  content  = templatefile("${path.module}/templates/init-configserver.js.tpl", { names = stackpath_compute_workload.mc.instances[*].name, stack = var.stackpath_stack })
  filename = "${path.module}/scripts/init-configserver.js"
}
