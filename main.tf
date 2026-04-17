module "keys" {
    source = "./modules/keys"
    template = var.template
}

module "dns" {
    source = "./modules/dns"
    template = var.template
    keys = module.keys.bloxone_keys_tsig
}

output "dns" {
  value = module.dns
}