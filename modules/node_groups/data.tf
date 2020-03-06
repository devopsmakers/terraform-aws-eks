data "aws_iam_policy_document" "node_groups_assume_role_policy" {
  statement {
    sid = "EKSNodeGroupAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
