terraform {

  required_version = "~> 1.3"

  required_providers {

    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

  }
}
