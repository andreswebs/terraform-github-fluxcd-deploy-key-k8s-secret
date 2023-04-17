
locals {

  github_domain        = "github.com"
  github_meta_endpoint = "https://api.${local.github_domain}/meta"
  github_api_version   = "2022-11-28"

}

data "http" "github_meta" {
  url = local.github_meta_endpoint

  request_headers = {
    Accept               = "application/vnd.github+json"
    X-GitHub-Api-Version = local.github_api_version
  }
}


resource "null_resource" "github_res_check" {
  provisioner "local-exec" {
    command = contains([200], data.http.github_meta.status_code)
  }
}

locals {
  github_res         = jsondecode(data.http.github_meta.response_body)
  github_ssh_keys    = local.github_res.ssh_keys
  github_known_hosts = join("\n", [for key in local.github_ssh_keys : "${local.github_domain} ${key}"])
}