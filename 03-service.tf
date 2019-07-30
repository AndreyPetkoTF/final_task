resource "aws_ecs_service" "nginx" {
  name            = "nginx"
  cluster         = "${aws_ecs_cluster.andrey.id}"
  task_definition = "${aws_ecs_task_definition.service.id}"
  desired_count   = 2
//  iam_role        = "${aws_iam_role.ecs_agent.id}"
//  depends_on      = ["aws_iam_role_policy.foo"]

  load_balancer {
    target_group_arn = "${aws_alb_target_group.andrey.id}"
    container_name   = "nginx"
    container_port   = 80
  }

//  placement_constraints {
//    type       = "memberOf"
//    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
//  }
}
