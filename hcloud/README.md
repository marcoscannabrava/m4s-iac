<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 3.0 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | 1.38.2 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 3.35.0 |
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | 1.38.2 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.3.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_record.root](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_record.www](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [hcloud_network.private](https://registry.terraform.io/providers/hetznercloud/hcloud/1.38.2/docs/resources/network) | resource |
| [hcloud_network_subnet.private](https://registry.terraform.io/providers/hetznercloud/hcloud/1.38.2/docs/resources/network_subnet) | resource |
| [hcloud_server.server](https://registry.terraform.io/providers/hetznercloud/hcloud/1.38.2/docs/resources/server) | resource |
| [hcloud_ssh_key.server_ssh_key](https://registry.terraform.io/providers/hetznercloud/hcloud/1.38.2/docs/resources/ssh_key) | resource |
| [local_file.ssh_public_key_openssh](https://registry.terraform.io/providers/hashicorp/local/2.3.0/docs/resources/file) | resource |
| [local_sensitive_file.ssh_private_key_openssh](https://registry.terraform.io/providers/hashicorp/local/2.3.0/docs/resources/sensitive_file) | resource |
| [null_resource.ansible_configuration](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.ssh_setup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.global_key](https://registry.terraform.io/providers/hashicorp/tls/4.0.4/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_token"></a> [cloudflare\_token](#input\_cloudflare\_token) | Cloudflare API token used to add DNS records | `string` | n/a | yes |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | Cloudflare Zone ID | `string` | n/a | yes |
| <a name="input_hcloud_token"></a> [hcloud\_token](#input\_hcloud\_token) | Hetzner Cloud API token used to create infrastructure | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain URL to point server to | `string` | `"example.com"` | no |
| <a name="input_hcloud_image"></a> [hcloud\_image](#input\_hcloud\_image) | System image to be used for all instances | `string` | `"ubuntu-22.04"` | no |
| <a name="input_hcloud_location"></a> [hcloud\_location](#input\_hcloud\_location) | Hetzner location used for all resources | `string` | `"hil"` | no |
| <a name="input_hcloud_server"></a> [hcloud\_server](#input\_hcloud\_server) | Type of instance to be used for all instances | `string` | `"cpx21"` | no |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | Network to create for private communication | `string` | `"10.0.0.0/8"` | no |
| <a name="input_network_ip_range"></a> [network\_ip\_range](#input\_network\_ip\_range) | Subnet to create for private communication. Must be part of the CIDR defined in `network_cidr`. | `string` | `"10.0.1.0/24"` | no |
| <a name="input_network_zone"></a> [network\_zone](#input\_network\_zone) | Zone to create the network in | `string` | `"us-west"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `"quickstart"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_server_ip"></a> [server\_ip](#output\_server\_ip) | n/a |
<!-- END_TF_DOCS -->