mock_provider "matchbox" {}
mock_provider "ct" {}

override_module {
  target = module.bootstrap
  outputs = {
    cluster_dns_service_ip = "10.3.0.10"
    kubeconfig-kubelet     = "kubeconfig"
    kubeconfig-admin       = "kubeconfig"
    etcd_ca_cert           = ""
    etcd_client_cert       = ""
    etcd_client_key        = ""
    etcd_server_cert       = ""
    etcd_server_key        = ""
    etcd_peer_cert         = ""
    etcd_peer_key          = ""
    apiserver_manifest     = ""
    manifests              = {}
    assets_dist            = {}
  }
}

variables {
  cluster_name           = "test"
  matchbox_http_endpoint = "http://matchbox.example.com:8080"
  os_version             = "44.20260928.3.1"
  k8s_domain_name        = "c.example.com"
  ssh_authorized_key     = "ssh-ed25519 AAAA"
  controllers            = [{ name = "c1", mac = "52:54:00:00:00:01", domain = "c1.example.com" }]
}

run "controller_defaults_to_x86_64" {
  command = plan

  assert {
    condition     = matchbox_profile.controllers[0].kernel == "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/44.20260928.3.1/x86_64/fedora-coreos-44.20260928.3.1-live-kernel.x86_64"
    error_message = "controller kernel should be x86_64 by default"
  }
}

run "arm64_controller_cached" {
  command = plan

  variables {
    controller_arch = "arm64"
    cached_install  = true
  }

  assert {
    condition     = matchbox_profile.controllers[0].kernel == "/assets/fedora-coreos/fedora-coreos-44.20260928.3.1-live-kernel.aarch64"
    error_message = "controller kernel should be aarch64"
  }

  assert {
    condition     = matchbox_profile.controllers[0].initrd == tolist(["/assets/fedora-coreos/fedora-coreos-44.20260928.3.1-live-initramfs.aarch64.img"])
    error_message = "controller initrd should be aarch64"
  }

  assert {
    condition     = contains(matchbox_profile.controllers[0].args, "coreos.live.rootfs_url=http://matchbox.example.com:8080/assets/fedora-coreos/fedora-coreos-44.20260928.3.1-live-rootfs.aarch64.img")
    error_message = "controller rootfs should be aarch64"
  }
}

run "arm64_controller_remote" {
  command = plan

  variables {
    controller_arch = "arm64"
  }

  assert {
    condition     = matchbox_profile.controllers[0].kernel == "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/44.20260928.3.1/aarch64/fedora-coreos-44.20260928.3.1-live-kernel.aarch64"
    error_message = "remote kernel should be the aarch64 build"
  }
}

run "mixed_arch_workers" {
  command = plan

  variables {
    cached_install = true
    workers = [
      { name = "w1", mac = "52:54:00:00:00:02", domain = "w1.example.com" },
      { name = "w2", mac = "52:54:00:00:00:03", domain = "w2.example.com", arch = "arm64" },
    ]
  }

  assert {
    condition     = module.workers[0].profile_kernel == "/assets/fedora-coreos/fedora-coreos-44.20260928.3.1-live-kernel.x86_64"
    error_message = "worker without arch should default to x86_64"
  }

  assert {
    condition     = module.workers[1].profile_kernel == "/assets/fedora-coreos/fedora-coreos-44.20260928.3.1-live-kernel.aarch64"
    error_message = "arm64 worker should use aarch64"
  }
}

run "rejects_bad_controller_arch" {
  command = plan

  variables {
    controller_arch = "x86_64"
  }

  expect_failures = [var.controller_arch]
}

run "rejects_bad_worker_arch" {
  command = plan

  variables {
    workers = [{ name = "w1", mac = "52:54:00:00:00:02", domain = "w1.example.com", arch = "x86_64" }]
  }

  expect_failures = [var.workers]
}
