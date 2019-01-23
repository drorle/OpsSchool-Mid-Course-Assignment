# Create the user-data for the Consul server
data "template_file" "prometheus" {
  count    = "${var.prometheus_count}"
  template = "${file("${path.module}/templates/prometheus.sh.tpl")}"

}

# INSTANCES #
resource "aws_instance" "prometheus_instance" {
  count                  = "${var.prometheus_count}"
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${element(aws_subnet.subnet.*.id,count.index % var.subnet_count)}"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}","${aws_security_group.prometheus.id}","${aws_security_group.outbound.id}"]
  key_name               = "${var.key_name}"
 
  tags {
    Name        = "${var.environment_tag}-prometheus-${count.index + 1}"
    Environment = "${var.environment_tag}"
  }

  user_data = "${element(data.template_file.prometheus.*.rendered, count.index)}"

  connection {
    type        = "ssh"
    agent       = "false"
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }

  # Enable Ansible by installing Python
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python",
    ]
  }
}
##################################################################################
# OUTPUT
##################################################################################

output "aws_prometheus_instance_public_dns" {
  value = "${aws_instance.prometheus_instance.*.public_ip}"
}


