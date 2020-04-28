module "md" {
  source    = "./modules/mongo_d"
  locations = local.locations
  stack     = var.stackpath_stack
}