
# Fork Changes

This repository is regularly rebased on its upstream parent.
This file tracks the differences between [upstream][upstream] and this fork.

[upstream]: https://github.com/poseidon/typhoon "poseidon/typhoon"

## 2026/11/15

- `bootstrap.tf` references the `alxbl/image-overrides` branch of [`alxbl/terraform-render-bootstrap`](https://github.com/alxbl/terraform-render-bootstrap)
- `bare-metal/fedora-coreos`: `container_image_overrides` replaces individual images (for example Cilium), keeping every other default
  - Cilium v1.18.9 (the upstream default) fails its BPF helper probe on Linux 7.2 on aarch64; v1.18.14 starts

## 2026/11/14

- `bare-metal/fedora-coreos`: select the Fedora CoreOS architecture (`amd64` or `arm64`), following the naming of the AWS module
  - `controller_arch` applies to all controllers
  - each entry of `workers` takes an optional `arch` (default `amd64`), so x86_64 and aarch64 workers can be mixed
  - `kernel_args` still applies cluster-wide
