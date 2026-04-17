module "keys" {
    source = "./modules/keys"
    template = var.template
}

module "dns" {
    source = "./modules/dns"
    template = var.template
    keys = module.keys.bloxone_keys_tsig
}

// Module debug, will be removed
output "dns" {
  value = module.dns
}