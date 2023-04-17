variable "k8s_namespace" {
  type        = string
  default     = "flux-system"
  description = "Name of the Kubernetes namespace where the resources will be deployed"
}

variable "k8s_namespace_labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the Kubernetes namespace when it is created"
}

variable "k8s_namespace_annotations" {
  type        = map(string)
  default     = {}
  description = "Annotations to apply to the Kubernetes namespace when it is created"
}


## github

variable "git_repository_name" {
  type        = string
  description = "Name of the Git repository to store the FluxCD manifests"
}

variable "git_branch" {
  type        = string
  default     = "main"
  description = "Git branch"
}

variable "github_ssh_domain" {
  type        = string
  description = "Domain to use for SSH to GitHub"
  default     = "github.com"
}

variable "github_owner" {
  type        = string
  description = "GitHub owner"
}

variable "github_deploy_key_title" {
  type        = string
  default     = "flux"
  description = "GitHub deploy key title"
}

variable "github_deploy_key_readonly" {
  type        = bool
  default     = true
  description = "Set the GitHub deploy key as read-only?"
}

## end github

variable "flux_secret_name" {
  type        = string
  default     = "flux-system" #tfsec:ignore:general-secrets-sensitive-in-variable
  description = "The name of the secret that is referenced by `GitRepository`, used by flux to deploy to the git repository"
}

## end flux

## conditional resources

variable "create_namespace" {
  type        = bool
  description = "Create the Kubernetes namespace?"
  default     = true
}

## end conditional resources
