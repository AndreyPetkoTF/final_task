output "AMI" {
  value = "${data.aws_ami.latest_ecs.id}"
}
