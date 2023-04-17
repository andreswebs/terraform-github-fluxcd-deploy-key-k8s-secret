output "k8s_namespace" {
  value       = var.create_namespace ? kubernetes_namespace.this[0] : null
  description = "The `kubernetes_namespace` resource"
}

output "k8s_namespace_name" {
  value       = local.k8s_namespace_name
  description = "The name (`metadata.name`) of the namespace"
}

output "deploy_key" {
  value       = tls_private_key.this
  description = "The `tls_private_key` resource: SSH key added to the GitHub repository"
  sensitive   = true
}

output "known_hosts" {
  value       = local.github_known_hosts
  description = "Known hosts for GitHub's SSH domain"
}

output "github_repository" {
  value       = data.github_repository.this
  description = "`data.github_repository` GitHub repository used by flux"
}
