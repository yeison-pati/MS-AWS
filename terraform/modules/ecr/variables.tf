variable "service_names" {
  description = "A list of microservice names to create ECR repositories for."
  type        = list(string)
}
