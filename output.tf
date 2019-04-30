output "ad_client_site_ip" {
  value = "${aws_instance.adclient.private_ip}"
}
