resource "bloxone_keys_tsig" "tsig" {
  for_each = {
    for key in var.template.keys :
    key.name => key
  }

  name = each.value.name

  # Other optional fields
  comment   = each.value.comment
  algorithm = each.value.algorithm
  secret    = each.value.secret
  tags      = each.value.tags
}

output "bloxone_keys_tsig" {
  value = bloxone_keys_tsig.tsig
  sensitive = true
}

####################
# INPUT VARIABLE
####################
variable "template" {
    type = object({
        keys = list(object({
            name = string
            secret = optional(string)
            comment = optional(string)
            algorithm = optional(string)
            tags = optional(map(string))
        }))
    })
}