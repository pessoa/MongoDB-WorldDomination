resource "stackpath_compute_workload" "agent" {
  count = 1
  name = "agent"
  slug = "agent"

  # Define multiple labels on the workload container.
  # access is used in the network policy
  labels = {
    "role"   = "agent-node"
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
    name = "agent"
    # image to use for the container
    image = "neowaylabs/mongodb-mms-agent:latest"
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

    # Environment variables exposed to the container are defined as key/value
    # pairs. You can define multiple environment variables for each container.
    # Each environment variable defined in a container must be unique within
    # that container.
    env {
      key   = "MMS_GROUP_ID"
      value = "5dd3dfa379358e661edc1024"
    }
    # You can also define sensitive environment variables using the secret_value
    # option. This values are not exposed in the API and are only exposed to
    # your container at runtime.
    env {
      key   = "MMS_API_KEY"
      secret_value = var.mms_api_key
    }    
  }

  # the config servers go to 3 different continents
  target {
    name             = "agent"
    min_replicas     = 1
    deployment_scope = "cityCode"
    selector {
      key      = "cityCode"
      operator = "in"
      values = [ "FRA" ]
    }
  }
}