
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_ami" "latest_ecs" {
  most_recent = true
  owners = ["591542846629"] # AWS

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
data "template_file" "user_data" {
  template = "${file("${path.module}/template/user_data.yaml")}"

  vars {
    ecs_cluster = "${var.project}"
  }
}

resource "aws_ecs_cluster" "andrey" {
  name = "${var.project}"
}

# Define the role.
resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_agent.json}"
}

# Give this role the permission to do ECS Agent things.
resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = "${aws_iam_role.ecs_agent.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = "${aws_iam_role.ecs_agent.name}"
}

resource "aws_launch_configuration" "cluster" {
//  name                 = "${var.project}"
  image_id             = "ami-0dca97e7cde7be3d5"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_agent.name}"
  user_data            = "${data.template_file.user_data.rendered}"
  instance_type        = "${var.instace_type}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.ecs_cluster.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "cluster" {
//  name                 = "${var.project}"
  vpc_zone_identifier  = ["${aws_subnet.public.id}", "${aws_subnet.public-2.id}"]
  launch_configuration = "${aws_launch_configuration.cluster.name}"

  desired_capacity = "${var.desired_capacity}"
  min_size         = "${var.min_size}"
  max_size         = "${var.max_size}"
}
