## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |
| aws.us | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| bucket\_name | Bucket name where the site is hosted. Must be equal to DNS name. Eg: hello.mysite.com | `string` | n/a | yes |
| dns\_zone | FQDN DNS zone. Eg: mysite.com | `any` | n/a | yes |
| tags | Tags used for billing and RBAC. | `map(string)` | n/a | yes |

## Outputs

No output.
