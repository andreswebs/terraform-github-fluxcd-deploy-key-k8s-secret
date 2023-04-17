locals {
  flux_default_namespace = "flux-system"
  k8s_namespace_norm     = var.k8s_namespace == "" || var.k8s_namespace == null ? local.flux_default_namespace : var.k8s_namespace
}

resource "kubernetes_namespace" "this" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name        = local.k8s_namespace_norm
    labels      = var.k8s_namespace_labels
    annotations = var.k8s_namespace_annotations
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
      metadata[0].annotations,
    ]
  }

}

locals {
  k8s_namespace      = var.create_namespace ? kubernetes_namespace.this[0] : null
  k8s_namespace_name = var.create_namespace ? local.k8s_namespace.metadata[0].name : local.k8s_namespace_norm
}

resource "null_resource" "k8s_namespace" {
  triggers = {
    "name" = local.k8s_namespace_name
  }
}
