variable "template" {
    type = object({
        dns_views = list(object({
            name = string
            comment = string
            auth_domains = list(object({
                fqdn = string
                comment = string
                nsgs = optional(list(string))
            }))
            fwd_domains = list(object({
                fqdn = string
                comment = string
                nsgs = optional(list(string))
            }))
            match_clients_acls = optional(list(string))
        }))
        dns_nsgs = list(object({
            name = string
            comment = string
            internal_secondaries = list(string)
            external_secondaries = optional(list(object({
                address = string
                fqdn = string
                tsig_enabled = bool
                tsig_key = optional(string)
            })))
        }))
        dns_acls = list(object({
            name = string
            comment = optional(string)
            tags = optional(map(string))
            list = optional(list(object({
                access = string
                element = string
                address = optional(string)
            })))
        }))
        keys = list(object({
            name = string
            secret = optional(string)
            comment = optional(string)
            algorithm = optional(string)
            tags = optional(map(string))
        }))
    })
}