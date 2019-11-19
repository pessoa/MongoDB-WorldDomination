locals {
  locations = [ "MAD", "FRA", "LHR"]
        /* "IAD", "JFK", "ORD", "ATL", "MIA",
        "DFW", "DEN", "SEA", "LAX", "SJC",
        "YYZ", "AMS", "LHR", "FRA", "WAW",
        "SIN", "GRU", "MEL", "NRT", "MAD",
        "ARN", "HKG",
      ] */
}


# these secrets are loaded from "somewhere else" with a .tfvars file
variable "stackpath_stack" {
}
variable "stackpath_client_id" {
}
variable "stackpath_client_secret" {
}
variable "allowed_ingress" {
}
