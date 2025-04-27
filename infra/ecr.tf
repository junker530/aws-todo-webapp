# ------------------------------------
# ECR
# ------------------------------------
resource "aws_ecr_repository" "webapp" {
  name                 = "${var.project}-${var.environment}-ecr-webapp"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}