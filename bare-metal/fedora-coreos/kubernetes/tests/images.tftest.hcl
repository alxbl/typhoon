mock_provider "matchbox" {}
mock_provider "ct" {}

variables {
  cluster_name           = "test"
  matchbox_http_endpoint = "http://matchbox.example.com:8080"
  os_version             = "44.20260928.3.1"
  k8s_domain_name        = "c.example.com"
  ssh_authorized_key     = "ssh-ed25519 AAAA"
  controllers            = [{ name = "c1", mac = "52:54:00:00:00:01", domain = "c1.example.com" }]
}

run "default_cilium_image" {
  command = plan

  assert {
    condition     = anytrue([for manifest in values(nonsensitive(module.bootstrap.assets_dist)) : strcontains(manifest, "quay.io/cilium/cilium:v1.18.9")])
    error_message = "the default cilium image should be rendered"
  }
}

run "overridden_cilium_image" {
  command = plan

  variables {
    container_image_overrides = { cilium_agent = "quay.io/cilium/cilium:v9.9.9" }
  }

  assert {
    condition     = anytrue([for manifest in values(nonsensitive(module.bootstrap.assets_dist)) : strcontains(manifest, "quay.io/cilium/cilium:v9.9.9")])
    error_message = "the overridden cilium image should be rendered"
  }
}
