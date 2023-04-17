# terraform-github-fluxcd-deploy-key-k8s-secret

Generates a GitHub deploy key in an existing repository and saves it in a
Kubernetes secret in the format expected by the
[FluxCD](https://fluxcd.io/docs/) toolkit.

**Note**: This module will generate an SSH key pair and the public key will be
added to the existing GitHub repository. This key pair will be stored
unencrypted in the Terraform state. Make sure that only authorized users have
direct access to the Terraform state.

It is highly recommended to use a remote state backend supporting encryption at
rest. See [References](#references) for more information.

See the [examples](#usage) to use an externally generated key instead of using
this module.

[//]: # (BEGIN_TF_DOCS)


## Usage

Example:

```hcl
provider "github" {
  token = var.github_token
  owner = var.github_owner
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"
}

module "fluxcd_deploy_key" {
  source  = "andreswebs/fluxcd-deploy-key-k8s-secret/github"
  version = "1.0.0"

  k8s_namespace       = "flux-system"
  git_repository_name = var.flux_repository_name
  git_branch          = var.flux_git_branch
  github_owner        = var.flux_github_owner
}
```

To use an externally generated deploy key, first add the deploy public key to the GitHub repository (see [instructions](https://docs.github.com/en/developers/overview/managing-deploy-keys#setup-2)).
Then create a Kubernetes secret with the contents below:

```sh
kubectl create secret generic \
    flux-system \
    --namespace flux-system \
    --from-file=identity \
    --from-file=identity.pub \
    --from-literal=known_hosts="$(ssh-keyscan github.com)"
```

The key files must be named `identity` (private key) and `identity.pub` (public key).



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the Kubernetes namespace? | `bool` | `true` | no |
| <a name="input_flux_secret_name"></a> [flux\_secret\_name](#input\_flux\_secret\_name) | The name of the secret that is referenced by `GitRepository`, used by flux to deploy to the git repository | `string` | `"flux-system"` | no |
| <a name="input_git_branch"></a> [git\_branch](#input\_git\_branch) | Git branch | `string` | `"main"` | no |
| <a name="input_git_repository_name"></a> [git\_repository\_name](#input\_git\_repository\_name) | Name of the Git repository to store the FluxCD manifests | `string` | n/a | yes |
| <a name="input_github_deploy_key_readonly"></a> [github\_deploy\_key\_readonly](#input\_github\_deploy\_key\_readonly) | Set the GitHub deploy key as read-only? | `bool` | `true` | no |
| <a name="input_github_deploy_key_title"></a> [github\_deploy\_key\_title](#input\_github\_deploy\_key\_title) | GitHub deploy key title | `string` | `"flux"` | no |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | GitHub owner | `string` | n/a | yes |
| <a name="input_github_ssh_domain"></a> [github\_ssh\_domain](#input\_github\_ssh\_domain) | Domain to use for SSH to GitHub | `string` | `"github.com"` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Name of the Kubernetes namespace where the resources will be deployed | `string` | `"flux-system"` | no |
| <a name="input_k8s_namespace_annotations"></a> [k8s\_namespace\_annotations](#input\_k8s\_namespace\_annotations) | Annotations to apply to the Kubernetes namespace when it is created | `map(string)` | `{}` | no |
| <a name="input_k8s_namespace_labels"></a> [k8s\_namespace\_labels](#input\_k8s\_namespace\_labels) | Labels to apply to the Kubernetes namespace when it is created | `map(string)` | `{}` | no |

## Modules

No modules.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deploy_key"></a> [deploy\_key](#output\_deploy\_key) | The `tls_private_key` resource: SSH key added to the GitHub repository |
| <a name="output_github_repository"></a> [github\_repository](#output\_github\_repository) | `data.github_repository` GitHub repository used by flux |
| <a name="output_k8s_namespace"></a> [k8s\_namespace](#output\_k8s\_namespace) | The `kubernetes_namespace` resource |
| <a name="output_k8s_namespace_name"></a> [k8s\_namespace\_name](#output\_k8s\_namespace\_name) | The name (`metadata.name`) of the namespace |
| <a name="output_known_hosts"></a> [known\_hosts](#output\_known\_hosts) | Known hosts for GitHub's SSH domain |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 5.0 |
| <a name="provider_http"></a> [http](#provider\_http) | ~> 3.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.16 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 5.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.16 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [github_repository_deploy_key.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.flux_ssh](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [null_resource.github_res_check](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.k8s_namespace](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) | data source |
| [http_http.github_meta](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

[//]: # (END_TF_DOCS)

## Authors

**Andre Silva** - [@andreswebs](https://github.com/andreswebs)

## License

This project is licensed under the [Unlicense](UNLICENSE.md).

## References

<https://www.terraform.io/docs/language/state/sensitive-data.html>

<https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1>
