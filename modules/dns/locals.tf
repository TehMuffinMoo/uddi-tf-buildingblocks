locals {
  # Flatten views + auth domains so each zone is unique
  auth_zones = {
    for item in flatten([
      for view in var.template.dns_views : [
        for domain in view.auth_domains : {
          key       = "${view.name}:${domain.fqdn}"
          view_name = view.name
          fqdn      = domain.fqdn
          comment = domain.comment
          nsgs = domain.nsgs
        }
      ]
    ]) : item.key => item
  }

  dns_host_name_to_id = {
    for host in data.bloxone_dns_hosts.all_hosts.results :
    host.name => host.id
  }
}