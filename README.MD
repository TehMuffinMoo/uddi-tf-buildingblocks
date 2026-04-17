1) Rename `provider.tf.example` to `provider.tf` and update the `csp_url` and `api_key` parameters
2) Rename `provider.example.json` to a template name of your choice (i.e `mytemplate.json`) and update the template according to your environment
3) Run terraform using `terraform plan -var-file="mytemplate.json"`