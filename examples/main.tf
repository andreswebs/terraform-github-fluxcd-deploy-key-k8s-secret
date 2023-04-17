provider "github" {
  token = var.github_token
  owner = var.github_owner
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"
}

module "fluxcd_deploy_key" {
  source              = "github.com/andreswebs/terraform-github-fluxcd-deploy-key-k8s-secret"
  k8s_namespace       = "flux-system"
  git_repository_name = var.flux_repository_name
  git_branch          = var.flux_git_branch
  github_owner        = var.flux_github_owner
}
