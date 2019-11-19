module "md" {
  source    = "./modules/mongo_d"
  locations = local.locations
}