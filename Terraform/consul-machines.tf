# Create the user-data for the Consul server
data "template_file" "consul_server" {
  count    = "${var.consul_server_count}"
  template = "${file("${path.module}/templates/consul.sh.tpl")}"

  vars {
    consul_version = "${var.consul_version}"
    config = <<EOF
     "node_name": "${var.environment_tag}-consul-server-${count.index+1}",
     "server": true,
     "bootstrap_expect": 3,
     "ui": true,
     "client_addr": "0.0.0.0"
    EOF
  }
}

# INSTANCES #
resource "aws_instance" "consul_instance" {
  count                  = "${var.consul_server_count}"
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${element(aws_subnet.subnet.*.id,count.index % var.subnet_count)}"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}","${aws_security_group.consul.id}","${aws_security_group.outbound.id}"]
  key_name               = "${var.key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.consul-join.name}"

  tags {
    Name        = "${var.environment_tag}-consul-server-${count.index + 1}"
    consul_server = "true"
    Environment = "${var.environment_tag}"
  }

  user_data = "${element(data.template_file.consul_server.*.rendered, count.index)}"

  connection {
    type        = "ssh"
    agent       = "false"
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python",
    ]
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' --private-key ${var.private_key_path} consul.yml"
  }
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_consul_instance_public_dns" {
  value = "${aws_instance.consul_instance.*.public_ip}"
}


