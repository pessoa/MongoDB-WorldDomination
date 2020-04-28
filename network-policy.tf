resource "stackpath_compute_network_policy" "allow-mongodb-ip" {
  count = 1
  name = "Allow mongodb on 27017 to one IP"
  slug = "allow-mongodb-ip"

  instance_selector {
    key      = "access"
    operator = "in"
    values   = ["private"]
  }

  policy_types = ["INGRESS"]

  # The priority that should be given to the network policy. The
  # lower the number, the higher the priority.
  priority = 1000

  # An ingress policy defines the rules and actions that should be taken
  # for ingress traffic (traffic being received by your instance). Policies
  # can be created to either allow or deny traffic.
  #
  # You can define multiple ingress policies for your network policy.
  ingress {
    # The action that should be taken for this policy. You can either
    # BLOCK or ALLOW traffic based on this policy.
    action = "ALLOW"
    protocol {
      # Config
      tcp {
        # Only apply the network policy to TCP connections on port 80.
        destination_ports = [27017, 27019]
      }
    }
    from {
      ip_block {
        # the CIDR range this policy should apply to
        cidr = "62.48.247.18/32"
      }
    }
  }
}
resource "stackpath_compute_network_policy" "block-all" {
  count = 0
  name = "Block all traffic"
  slug = "block-all"

  policy_types = ["INGRESS"]

  # The priority that should be given to the network policy. The
  # lower the number, the higher the priority.
  priority = 1001

  # An ingress policy defines the rules and actions that should be taken
  # for ingress traffic (traffic being received by your instance). Policies
  # can be created to either allow or deny traffic.
  #
  # You can define multiple ingress policies for your network policy.
  ingress {
    # The action that should be taken for this policy. You can either
    # BLOCK or ALLOW traffic based on this policy.
    action = "BLOCK"
  }
}
