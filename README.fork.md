
# Fork Changes

This repository is regularly rebased on its upstream parent.
This file tracks the differences between [upstream][upstream] and this fork.

[upstream]: https://github.com/poseidon/typhoon "poseidon/typhoon"


## 2024/03/19

- `bootstrap.tf` references main branch of [`alxbl/terraform-render-bootstrap`](https://github.com/alxbl/terraform-render-bootstrap)

## 2024/02/27

- Add experimental rudimentary support for `bare-metal/fedora-coreos/aarch64`
  - Currently, controllers must all use the same architecture
  - Workers can be mixed architecture
