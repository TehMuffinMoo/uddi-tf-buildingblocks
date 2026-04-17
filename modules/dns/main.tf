####################
# DNS ACLs
####################
resource "bloxone_dns_acl" "dns_acl" {
  for_each = {
    for acl in var.template.dns_acls :
    acl.name => acl
  }

  name    = each.value.name
  comment = each.value.comment
  tags    = each.value.tags

  list = [
    for item in each.value.list :
    {
      access = item.access
      element = item.element
      address = item.address
    }
  ]
}

####################
# DNS VIEWS
####################
resource "bloxone_dns_view" "dns_view" {
  for_each = {
    for view in var.template.dns_views :
    view.name => view
  }

  name    = each.value.name
  comment = each.value.comment
  match_clients_acl = each.value.match_clients_acls != null ? [for acl_name in each.value.match_clients_acls : {
    "acl" = bloxone_dns_acl.dns_acl[acl_name].id
    "element" = "acl"
  }] : null
}

####################
# DNS NSGs
####################
resource "bloxone_dns_auth_nsg" "nsg" {
  for_each = {
    for nsg in var.template.dns_nsgs :
    nsg.name => nsg
  }

  name    = each.value.name
  comment = each.value.comment

  internal_secondaries = [
    for host_name in each.value.internal_secondaries :
    {
      host = local.dns_host_name_to_id[host_name]
    }
  ]
  // Only add external_secondaries if each.value.external_secondaries > 0 to avoid API errors about missing fields
  external_secondaries = length(each.value.external_secondaries) > 0 ? [
    for secondary in each.value.external_secondaries :
    {
      address = secondary.address
      fqdn    = secondary.fqdn
      tsig_enabled = secondary.tsig_enabled
      // Only if tsig_enabled is true and tsig_key is provided, add tsig_key to avoid API errors about missing fields
      tsig_key = secondary.tsig_enabled && secondary.tsig_key != null ? {key = var.keys[secondary.tsig_key].id} : null
    }
  ] : null
}

####################
# AUTH ZONES
####################
resource "bloxone_dns_auth_zone" "auth_zone" {
  for_each = local.auth_zones

  fqdn         = each.value.fqdn
  primary_type = "cloud"
  view         = bloxone_dns_view.dns_view[each.value.view_name].id
  comment      = each.value.comment
  nsgs         = [for nsg_name in each.value.nsgs : bloxone_dns_auth_nsg.nsg[nsg_name].id]
}