resource "stackpath_compute_workload" "router" {
  name = "router"
  slug = "router"

  annotations = {
    # request an anycast IP for a workload
    "anycast.platform.stackpath.net" = "true"
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
    command = ["/usr/bin/mongos", "--bind_ip_all", "--port", "27017", "--configdb", "configserver/${join(":27019,",stackpath_compute_workload.mc.instances[*].ip_address)}"]
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
    name             = "router"
    min_replicas     = 1
    deployment_scope = "cityCode"
    selector {
      key      = "cityCode"
      operator = "in"
      values = local.locations
    }
  }
}

resource "local_file" "init_router" {
  content  = templatefile("${path.module}/templates/init-router.js.tpl", { instances = module.md.md-workload-instances})
  filename = "${path.module}/scripts/init-router.js"
}