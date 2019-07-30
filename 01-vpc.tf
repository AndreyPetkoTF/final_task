resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_range}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.project}-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-2a"

  tags {
    Name = "${var.project}-public"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_subnet_cidr-2}"
  availability_zone = "us-east-2b"

  tags {
    Name = "${var.project}-public-2"
  }
}
