# INSTANCES #
resource "aws_instance" "consul_instance" {
  count                  = "${var.consul_instance_count}"
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${element(aws_subnet.subnet.*.id,count.index % var.subnet_count)}"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}","${aws_security_group.consul.id}","${aws_security_group.outbound.id}"]
  key_name               = "${var.key_name}"

  tags {
    Name        = "${var.environment_tag}-consul-${count.index + 1}"
    Environment = "${var.environment_tag}"
  }

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


