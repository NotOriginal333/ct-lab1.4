module "label" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"
  context = var.context
  name    = var.name
}

module "label_get_all_authors" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.25.0"
  context = var.context
  name    = "get-all-authors"
}

module "lambda_get_all_authors" {
  source        = "terraform-aws-modules/lambda/aws"
  version       = "7.20.1"
  function_name = module.label_get_all_authors.id
  description   = "My awesome lambda function"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  source_path = "${path.module}/src/get-all-authors"

  environment_variables = {
    TABLE_NAME = var.authors_table
  }
  attach_policy_statements = true

  policy_statements = {
    dynamodb = {
      effect    = "Allow",
      actions   = ["dynamodb:Scan"],
      resources = ["${var.authors_table_arn}"]
    }
  }

  tags = module.label.tags
}
