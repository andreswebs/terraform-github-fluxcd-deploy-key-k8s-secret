## github repository

data "github_repository" "this" {
  full_name = "${var.github_owner}/${var.git_repository_name}"
}

resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "github_repository_deploy_key" "this" {
  title      = var.github_deploy_key_title
  repository = data.github_repository.this.name
  key        = tls_private_key.this.public_key_openssh
  read_only  = var.github_deploy_key_readonly
}

## end github repository

## secret

resource "kubernetes_secret" "flux_ssh" {
  depends_on = [
    github_repository_deploy_key.this,
    null_resource.k8s_namespace,
  ]

  metadata {
    name      = var.flux_secret_name
    namespace = local.k8s_namespace_name
  }

  data = {
    "identity"     = tls_private_key.this.private_key_pem
    "identity.pub" = tls_private_key.this.public_key_openssh
    "known_hosts"  = local.github_known_hosts
  }
}

## end secret
