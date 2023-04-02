output "m4s_url" {
  value = join(".", ["m4s", hcloud_server.m4s_server.ipv4_address, "sslip.io"])
}

output "m4s_ip" {
  value = hcloud_server.m4s_server.ipv4_address
}
