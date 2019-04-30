resource "aws_instance" "adclient" {
  instance_type               = "${var.instance_type}"
  ami                         = "${var.ami}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
  subnet_id                   = "${var.subnet_id}"
  iam_instance_profile        = "${var.instance_profile}"
  private_ip                  = "${var.private_ip}"
  associate_public_ip_address ="${var.associate_public_ip_address}"
  user_data                   = "${data.template_file.user_data_shell.rendered}"
  tags                        = "${merge(map("Name", format("%s", var.name_tag)), var.tags)}"
}

data "template_file" "user_data_shell" {
 template = <<-EOF
                <powershell>
                # install required software
                Install-WindowsFeature RSAT-ADLDS
		            Install-WindowsFeature RSAT-AD-PowerShell
                Install-WindowsFeature RSAT-AD-Tools
                Install-WindowsFeature RSAT-DNS-Server
                Install-WindowsFeature GPMC
                </powershell>
              EOF
}

resource "aws_ssm_association" "ssm_document_my_ad" {
   name        = "${var.ssm_document_name}"
  instance_id = "${aws_instance.adclient.id}"
  depends_on = ["aws_instance.adclient"]
}
