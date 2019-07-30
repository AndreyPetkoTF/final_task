resource "aws_alb" "alb" {
  name            = "itea-devops-balancer"
  subnets         = ["${aws_subnet.public.id}", "${aws_subnet.public-2.id}"]
  security_groups = ["${aws_security_group.ecs_cluster.id}"]
//  internal         = true
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.alb.id}"
  port              = "8081"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "HEALTHY"
      status_code = "200"
    }
  }
}
