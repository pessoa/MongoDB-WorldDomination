# shards
resource "local_file" "up" {
  count = length(local.locations)
  content  = templatefile("${path.module}/templates/up.sh.tpl", {
    md_ip_addrs = module.md.md-workload-instances[*][0].external_ip_address,
    mc_ip = stackpath_compute_workload.mc.instances[0].external_ip_address,
    router_ip = stackpath_compute_workload.router.instances[0].external_ip_address,
    locations = local.locations})
  filename = "${path.root}/scripts/up.sh"
}